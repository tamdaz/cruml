require "compiler/crystal/syntax"
require "./class_list"
require "./module_list"

# Class that consists to inspect the reflected objects.
class Cruml::Transformer < Crystal::Transformer
  INCLUDE_REGEX                  = /^include (\w+(?:::\w+)*)$/
  CLASS_VARS_ATTRIBUTE_REGEX     = /(class_getter|class_property|class_setter)\((\w+) : (\w+)\)/
  INSTANCE_VARS_ATTTRIBUTE_REGEX = /^(property|getter|setter|property\?|getter\?)\((\w+) : ([\w:| ]+)\)/
  INSTANCE_VARS_REGEX            = /^@(\w+) : ([\w:| ]+)$/

  def initialize
    @current_class_name = ""
    @current_module_name = ""
    @variables = [] of Crystal::TypeDeclaration
    @protected_and_private_methods = [] of Crystal::Def
  end

  # Transforms a module definition node.
  def transform(node : Crystal::ModuleDef) : Crystal::ASTNode
    @current_module_name = node.name.to_s

    if @current_module_name.downcase.ends_with?("interface")
      Cruml::ModuleList.add(Cruml::Entities::ModuleInfo.new(@current_module_name, :interface))
    else
      Cruml::ModuleList.add(Cruml::Entities::ModuleInfo.new(@current_module_name))
    end

    super(node)
  end

  # Transforms a class definition node.
  def transform(node : Crystal::ClassDef) : Crystal::ASTNode
    @current_class_name = node.name.to_s
    @current_module_name = ""

    # If a class def contains the generic.
    if node.type_vars
      generic = node.type_vars.as(Array(String))
      @current_class_name += "(#{generic.join(", ")})"
    end

    class_info = Cruml::Entities::ClassInfo.new(@current_class_name, class_type(@current_class_name, node))

    if node.superclass
      class_info.add_parent_class(node.superclass.to_s)
    end

    Cruml::ClassList.add(class_info)

    # Check if there's an "include" keyword followed by a module
    node.body.to_s.each_line do |line|
      if match_include = line.match(INCLUDE_REGEX)
        included_module = match_include[1]

        found_class = Cruml::ClassList.find_by_name(@current_class_name)

        if found_class
          found_class.add_included_module(included_module)
        end
      end
    end

    if match_class_vars = node.body.to_s.match(CLASS_VARS_ATTRIBUTE_REGEX)
      visibility, name, type = match_class_vars

      found_class = Cruml::ClassList.find_by_name!(@current_class_name)

      found_class.tap do |klass|
        klass.add_class_var("@@#{name}", type)

        if ["class_property", "class_getter", "class_property?", "class_getter?"].includes?(visibility)
          klass.add_method(Cruml::Entities::MethodInfo.new(:public, name, type))
        end

        if ["class_property", "class_setter", "class_property?"].includes?(visibility)
          klass.add_method(Cruml::Entities::MethodInfo.new(:public, "#{name}=", type))
        end
      end
    end

    super(node)
  end

  # Transforms a visibility modifier node.
  def transform(node : Crystal::VisibilityModifier) : Crystal::ASTNode
    method = node.exp.as(Crystal::Def)

    @protected_and_private_methods << method

    if @current_module_name.empty?
      # Add a method into class.
      found_class = Cruml::ClassList.find_by_name!(@current_class_name)

      method_with_visibility = Cruml::Entities::MethodInfo.new(visibility(node.modifier), method.name.to_s, method.return_type.to_s)
      add_args(method, method_with_visibility)

      found_class.add_method(method_with_visibility)
    else
      # Add a method into module.
      found_module = Cruml::ModuleList.find_by_name!(@current_module_name)

      found_module.add_method(
        Cruml::Entities::MethodInfo.new(visibility(node.modifier), method.name.to_s, method.return_type.to_s)
      )
    end

    super(node)
  end

  # Transforms an expressions node.
  def transform(node : Crystal::Expressions) : Crystal::ASTNode
    node.expressions.each do |exp|
      if match = exp.to_s.match(INSTANCE_VARS_ATTTRIBUTE_REGEX)
        visibility, name, type = match[1], match[2], match[3]

        found_class = Cruml::ClassList.find_by_name!(@current_class_name)

        found_class.tap do |class_info|
          class_info.add_instance_var("@#{name}", type)

          if ["property", "getter", "property?", "getter?"].includes?(visibility)
            class_info.add_method(Cruml::Entities::MethodInfo.new(:public, name, type))
          end

          if ["property", "setter", "property?"].includes?(visibility)
            class_info.add_method(Cruml::Entities::MethodInfo.new(:public, "#{name}=", type))
          end
        end
      end
    end

    super(node)
  end

  # Transforms an instance variable node.
  def transform(node : Crystal::InstanceVar) : Crystal::ASTNode
    ivar_name = node.name.to_s

    @variables.each do |variable|
      var_name, var_type = variable.var.to_s, variable.declared_type.to_s

      if var_name.includes?(ivar_name)
        if !@current_module_name.empty?
          Cruml::ModuleList.find_by_name!(@current_module_name).add_instance_var(var_name, var_type)
        else
          Cruml::ClassList.find_by_name!(@current_class_name).add_instance_var(var_name, var_type)
        end
      end
    end

    super(node)
  end

  # Transforms an assignment node.
  def transform(node : Crystal::Assign) : Crystal::ASTNode
    @variables.each do |var|
      if node.target.to_s.includes?(var.var.to_s)
        Cruml::ClassList.find_by_name!(@current_class_name).add_instance_var(
          node.target.to_s, var.declared_type.to_s.gsub(" ::", ' ')
        )
      end
    end

    super(node)
  end

  # Transforms a type declaration node.
  def transform(node : Crystal::TypeDeclaration) : Crystal::ASTNode
    @variables |= [node]
    super(node)
  end

  # Transforms a method definition node.
  def transform(node : Crystal::Def) : Crystal::ASTNode
    is_not_duplicated_method = @protected_and_private_methods.none? do |method|
      method.name == node.name
    end

    node.args.each do |arg|
      arg_name = arg.name.to_s
      node.body.to_s.each_line do |line|
        if match = line.match(/^@(\w+) = #{arg_name}$/)
          ivar_name = match[1]
          found_class = Cruml::ClassList.find_by_name!(@current_class_name)
          found_class.add_instance_var("@#{ivar_name}", arg.restriction.to_s)
        end
      end
    end

    if match_instance_var = node.body.to_s.match(INSTANCE_VARS_REGEX)
      ivar_name, ivar_type = match_instance_var

      Cruml::ClassList.find_by_name!(@current_class_name).add_instance_var("@#{ivar_name}", ivar_type)
    end

    if is_not_duplicated_method
      return_type = node.return_type.to_s || "Nil"
      visibility = node.name.to_s == "initialize" ? :protected : :public
      method_name = node.receiver ? "self\\.#{node.name}" : node.name

      method_info = Cruml::Entities::MethodInfo.new(visibility, method_name, return_type)
      add_args(node, method_info)

      if !@current_module_name.empty?
        # Add a method into module.
        found_module = Cruml::ModuleList.find_by_name!(@current_module_name)
        found_module.add_method(method_info)
      else
        # Add a method into class.
        found_class = Cruml::ClassList.find_by_name!(@current_class_name)
        found_class.add_method(method_info)
      end
    end

    super(node)
  end

  # Add arguments for methods.
  private def add_args(node : Crystal::Def, method : Cruml::Entities::MethodInfo) : Void
    node.args.map(&.to_s).each do |arg|
      if arg.includes?(" : ")
        arg_name, arg_type = arg.split(" : ")
        arg_type.gsub(" ::", ' ')

        method.add_arg(Cruml::Entities::ArgInfo.new(arg_name, arg_type))
      end
    end
  end

  # Determines the class type.
  private def class_type(class_name : String, node : Crystal::ClassDef)
    if class_name.downcase.ends_with?("interface")
      :interface
    else
      node.abstract? ? :abstract : :class
    end
  end

  # Determines the visibility of a node.
  private def visibility(modifier : Crystal::Visibility) : Symbol
    case modifier
    when Crystal::Visibility::Protected then :protected
    when Crystal::Visibility::Private   then :private
    else                                     :public
    end
  end
end
