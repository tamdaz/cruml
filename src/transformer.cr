require "compiler/crystal/syntax"
require "./services/registry_service"
require "./parsers/*"
require "./entities/*"

# Transformer that uses the Crystal AST for extracting the information about:
# - Classes (normal, abstract, interfaces)
# - Modules
# - Methods (with visibility modifiers)
# - Instance variables
# - Class variables
# - Inheritance relationships
# - Module inclusions
class Cruml::Transformer < Crystal::Transformer
  include Cruml::Parsers::RegexPatterns

  getter registry : Cruml::Services::RegistryService

  # Tracks the current context during AST traversal
  @current_class_name : String
  @current_module_name : String
  @variables : Array(Crystal::TypeDeclaration)
  @protected_and_private_methods : Array(Crystal::Def)

  # Stack to track nested modules
  @module_stack : Array(String)

  def initialize(@registry : Cruml::Services::RegistryService)
    @current_class_name = ""
    @current_module_name = ""
    @module_stack = [] of String
    @variables = [] of Crystal::TypeDeclaration
    @protected_and_private_methods = [] of Crystal::Def
  end

  # Transforms a module definition node
  def transform(node : Crystal::ModuleDef) : Crystal::ASTNode
    module_name = node.name.to_s

    # Build fully qualified module name
    @module_stack << module_name
    @current_module_name = @module_stack.join("::")

    process_module(node)
    result = super(node)

    # Pop the module from stack when done
    @module_stack.pop
    @current_module_name = @module_stack.join("::")

    result
  end

  # Transforms a class definition node
  def transform(node : Crystal::ClassDef) : Crystal::ASTNode
    class_name = node.name.to_s

    # Build fully qualified class name by prepending module stack
    if !@module_stack.empty?
      # Check if the class name already includes a namespace part
      if class_name.includes?("::")
        # Split the name and check if it overlaps with module_stack
        name_parts = class_name.split("::")

        # Remove overlapping parts from the beginning
        non_overlapping_start = 0
        @module_stack.reverse_each do |mod_part|
          if name_parts[non_overlapping_start]? == mod_part.split("::").last
            non_overlapping_start += 1
          else
            break
          end
        end
        remaining_parts = name_parts[non_overlapping_start..]
        @current_class_name = (@module_stack + remaining_parts).join("::")
      else
        @current_class_name = (@module_stack + [class_name]).join("::")
      end
    else
      @current_class_name = class_name
    end

    @current_module_name = ""

    process_class(node)
    super(node)
  end

  # Transforms a visibility modifier node (protected/private methods)
  def transform(node : Crystal::VisibilityModifier) : Crystal::ASTNode
    if method = node.exp.as?(Crystal::Def)
      @protected_and_private_methods << method
      add_method_with_visibility(node.modifier, method)
    end

    super(node)
  end

  # Transforms an expressions node
  def transform(node : Crystal::Expressions) : Crystal::ASTNode
    node.expressions.each do |exp|
      process_instance_attribute(exp)
    end

    super(node)
  end

  # Transforms an instance variable node
  def transform(node : Crystal::InstanceVar) : Crystal::ASTNode
    process_instance_var_node(node)
    super(node)
  end

  # Transforms an assignment node
  def transform(node : Crystal::Assign) : Crystal::ASTNode
    process_assign_node(node)
    super(node)
  end

  # Transforms a type declaration node
  def transform(node : Crystal::TypeDeclaration) : Crystal::ASTNode
    @variables |= [node]

    if node.var.is_a?(Crystal::ClassVar)
      process_class_var_declaration(node)
    end

    super(node)
  end

  # Transforms a method definition node
  def transform(node : Crystal::Def) : Crystal::ASTNode
    process_def_node(node)
    super(node)
  end

  private def process_module(node : Crystal::ModuleDef) : Nil
    # @current_module_name already contains the fully qualified name from transform()
    module_type = Cruml::Parsers::ClassParser.interface?(@current_module_name) ? :interface : :normal

    module_info = Cruml::Entities::ModuleInfo.new(@current_module_name, module_type)
    @registry.add_module(module_info)
  end

  private def process_class(node : Crystal::ClassDef) : Nil
    # Handle generic types
    if generics = Cruml::Parsers::ClassParser.extract_generics(node)
      @current_class_name += generics
    end

    # Determine class type
    class_type = Cruml::Parsers::ClassParser.determine_class_type(@current_class_name, node)

    # Create and register class info
    class_info = Cruml::Entities::ClassInfo.new(@current_class_name, class_type)

    # Add parent class with its type
    if node.superclass
      parent_name = node.superclass.to_s

      # Qualify parent class name with module stack if needed
      qualified_parent_name = qualify_name(parent_name)

      # Try to find with both qualified and unqualified names
      parent_class = @registry.find_class(qualified_parent_name) || @registry.find_class(parent_name)
      parent_type = parent_class ? parent_class.type : :class

      # Use the name that was found in registry, or the qualified name
      final_parent_name = parent_class ? parent_class.name : qualified_parent_name
      class_info.add_parent_class(final_parent_name, parent_type)
    end

    @registry.add_class(class_info)

    # Parse includes, extends, and class variables
    process_includes(node)
    process_extends(node)
    process_class_vars(node)
  end

  private def process_includes(node : Crystal::ClassDef) : Nil
    includes = Cruml::Parsers::ClassParser.parse_includes(node.body.to_s)

    if found_class = @registry.find_class(@current_class_name)
      includes.each do |mod|
        # Qualify the module name if it's relative
        qualified_mod = qualify_name(mod)

        # Try to find the module with both names
        if @registry.find_module(qualified_mod) || @registry.find_module(mod)
          found_class.add_included_module(qualified_mod)
        else
          # If module not found, still add it (might be external module)
          found_class.add_included_module(mod)
        end
      end
    end
  end

  private def process_extends(node : Crystal::ClassDef) : Nil
    extends = Cruml::Parsers::ClassParser.parse_extends(node.body.to_s)

    if found_class = @registry.find_class(@current_class_name)
      extends.each do |mod|
        # Qualify the module name if it's relative
        qualified_mod = qualify_name(mod)
        # Try to find the module with both names
        if @registry.find_module(qualified_mod) || @registry.find_module(mod)
          found_class.add_extended_module(qualified_mod)
        else
          # If module not found, still add it (might be external module)
          found_class.add_extended_module(mod)
        end
      end
    end
  end

  private def process_class_vars(node : Crystal::ClassDef) : Nil
    return unless class_var = Cruml::Parsers::VariableParser.parse_class_attribute(node.body.to_s)

    found_class = @registry.find_class(@current_class_name)
    return unless found_class

    found_class.add_class_var("@@#{class_var[:name]}", class_var[:type])

    # Add getter method if applicable
    if VisibilityHelpers.has_class_getter?(class_var[:visibility])
      method = Cruml::Entities::MethodInfo.new(:public, class_var[:name], class_var[:type])
      found_class.add_method(method)
    end

    # Add setter method if applicable
    if VisibilityHelpers.has_class_setter?(class_var[:visibility])
      method = Cruml::Entities::MethodInfo.new(:public, "#{class_var[:name]}=", class_var[:type])
      found_class.add_method(method)
    end
  end

  private def process_class_var_declaration(node : Crystal::TypeDeclaration) : Nil
    return unless node.var.is_a?(Crystal::ClassVar)

    var_name = node.var.as(Crystal::ClassVar).name
    var_type = node.declared_type.to_s

    if found_class = @registry.find_class(@current_class_name)
      # Here, there's no need to add "@@" before the cvar name.
      found_class.add_class_var(var_name, var_type)
    end
  end

  private def add_method_with_visibility(modifier : Crystal::Visibility, method : Crystal::Def) : Nil
    visibility = Cruml::Parsers::MethodParser.visibility_from_modifier(modifier)
    return_type = Cruml::Parsers::MethodParser.get_return_type(method)

    method_info = Cruml::Entities::MethodInfo.new(visibility, method.name.to_s, return_type)
    Cruml::Parsers::MethodParser.add_arguments(method, method_info)

    if @current_module_name.empty?
      if found_class = @registry.find_class(@current_class_name)
        found_class.add_method(method_info)
      end
    else
      if found_module = @registry.find_module(@current_module_name)
        found_module.add_method(method_info)
      end
    end
  end

  private def process_instance_attribute(exp) : Nil
    return unless attr = Cruml::Parsers::VariableParser.parse_instance_attribute(exp.to_s)

    found_class = @registry.find_class(@current_class_name)
    return unless found_class

    found_class.add_instance_var("@#{attr[:name]}", attr[:type])

    # Add getter method
    if VisibilityHelpers.has_getter?(attr[:visibility])
      found_class.add_method(Cruml::Entities::MethodInfo.new(:public, attr[:name], attr[:type]))
    end

    # Add setter method
    if VisibilityHelpers.has_setter?(attr[:visibility])
      found_class.add_method(Cruml::Entities::MethodInfo.new(:public, "#{attr[:name]}=", attr[:type]))
    end
  end

  private def process_instance_var_node(node : Crystal::InstanceVar) : Nil
    ivar_name = node.name.to_s

    @variables.each do |variable|
      var_name = variable.var.to_s
      var_type = variable.declared_type.to_s

      next unless Cruml::Parsers::VariableParser.matches_instance_var?(var_name, ivar_name)

      if @current_module_name.empty?
        if found_class = @registry.find_class(@current_class_name)
          found_class.add_instance_var(var_name, var_type)
        end
      else
        if found_module = @registry.find_module(@current_module_name)
          found_module.add_instance_var(var_name, var_type)
        end
      end
    end
  end

  private def process_assign_node(node : Crystal::Assign) : Nil
    @variables.each do |var|
      if node.target.to_s.includes?(var.var.to_s)
        clean_type = var.declared_type.to_s.gsub(" ::", ' ')

        if found_class = @registry.find_class(@current_class_name)
          found_class.add_instance_var(node.target.to_s, clean_type)
        end
      end
    end
  end

  private def process_def_node(node : Crystal::Def) : Nil
    # Skip if method was already processed with visibility modifier
    return if method_already_processed?(node)

    # Process instance variable assignments in constructor
    process_constructor_assignments(node)

    # Process instance variable declarations in method body
    process_method_body_vars(node)

    # Create and add method info
    add_public_method(node)
  end

  private def method_already_processed?(node : Crystal::Def) : Bool
    @protected_and_private_methods.any? { |method| method.name == node.name }
  end

  private def process_constructor_assignments(node : Crystal::Def) : Nil
    node.args.each do |arg|
      arg_name = arg.name.to_s

      node.body.to_s.each_line do |line|
        if ivar_name = Cruml::Parsers::VariableParser.parse_instance_var_assignment(line, arg_name)
          if found_class = @registry.find_class(@current_class_name)
            found_class.add_instance_var("@#{ivar_name}", arg.restriction.to_s)
          end
        end
      end
    end
  end

  private def process_method_body_vars(node : Crystal::Def) : Nil
    return unless var_decl = Cruml::Parsers::VariableParser.parse_instance_var_declaration(node.body.to_s)

    if found_class = @registry.find_class(@current_class_name)
      found_class.add_instance_var("@#{var_decl[:name]}", var_decl[:type])
    end
  end

  private def add_public_method(node : Crystal::Def) : Nil
    visibility = Cruml::Parsers::MethodParser.determine_visibility(node.name.to_s)
    method_name = Cruml::Parsers::MethodParser.format_method_name(node)
    return_type = Cruml::Parsers::MethodParser.get_return_type(node)

    method_info = Cruml::Entities::MethodInfo.new(visibility, method_name, return_type)
    Cruml::Parsers::MethodParser.add_arguments(node, method_info)

    if @current_module_name.empty?
      if found_class = @registry.find_class(@current_class_name)
        found_class.add_method(method_info)
      end
    else
      if found_module = @registry.find_module(@current_module_name)
        found_module.add_method(method_info)
      end
    end
  end

  # Qualifies a name (class or module) with the current module stack
  # Handles overlapping namespaces intelligently
  private def qualify_name(name : String) : String
    return name if @module_stack.empty?
    return name if name.empty?

    # Split both the full module stack and the name into parts
    stack_parts = @module_stack.flat_map(&.split("::"))
    name_parts = name.split("::")

    # Check if name already starts with full stack - if so, it's already qualified
    if name.starts_with?(@module_stack.join("::"))
      return name
    end

    # Find how many parts at the end of stack_parts match the beginning of name_parts
    overlap = 0

    stack_parts.reverse_each.each do |stack_part|
      if name_parts[overlap]? == stack_part
        overlap += 1
      else
        break if overlap > 0 # Stop if we found some overlap but it breaks
      end
    end

    if overlap > 0
      # Remove overlapping parts from name and append the rest to stack
      remaining_name_parts = name_parts[overlap..]
      (stack_parts + remaining_name_parts).join("::")
    else
      # No overlap found, just concatenate
      (stack_parts + name_parts).join("::")
    end
  end
end
