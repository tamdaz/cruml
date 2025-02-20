require "compiler/crystal/syntax"
require "./class_list"
require "./module_list"

class Cruml::Transformer < Crystal::Transformer
  def initialize
    @current_class_name = ""
    @current_module_name = ""
    @variables = [] of Crystal::TypeDeclaration
    @protected_and_private_methods = [] of Crystal::Def
  end

  def transform(node : Crystal::ModuleDef) : Crystal::ASTNode
    @current_module_name = node.name.to_s

    Cruml::ModuleList.add(Cruml::Entities::ModuleInfo.new(@current_module_name))

    super(node)
  end

  def transform(node : Crystal::ClassDef) : Crystal::ASTNode
    @current_class_name = node.name.to_s.gsub("::", ".")
    @current_module_name = ""

    # If a class def contains the generic
    if node.type_vars
      generic = node.type_vars.as(Array(String))
      @current_class_name += "~#{generic.join(", ")}~"
    end

    class_type = node.abstract? ? :abstract : :class
    class_info = Cruml::Entities::ClassInfo.new(@current_class_name, class_type)

    # Replace the "::" by "." for namespaces.
    if node.superclass
      class_info.add_inherit_class(node.superclass.to_s.gsub("::", "."))
    end

    Cruml::ClassList.add(class_info)

    # Check if there's an "include" keyword followed by a module
    node.body.to_s.each_line do |line|
      if match = line.match(/^include (\w+(?:::\w+)*)$/)
        included_module = match[1].gsub("::", ".")
        Cruml::ClassList.find_by_name!(@current_class_name).add_inherit_class(included_module)
      end
    end

    super(node)
  end

  def transform(node : Crystal::VisibilityModifier) : Crystal::ASTNode
    method = node.exp.as(Crystal::Def)
    method_name = method.receiver ? "self.#{method.name}" : method.name

    @protected_and_private_methods << method

    if @current_module_name.empty?
      # Add a method into class.
      Cruml::ClassList.find_by_name!(@current_class_name).add_method(
        Cruml::Entities::MethodInfo.new(visibility(node.modifier), method_name.to_s, method.return_type.to_s)
      )
    else
      # Add a method into module.
      Cruml::ModuleList.find_by_name!(@current_module_name).add_method(
        Cruml::Entities::MethodInfo.new(visibility(node.modifier), method_name.to_s, method.return_type.to_s)
      )
    end
    super(node)
  end

  private def visibility(modifier : Crystal::Visibility) : Symbol
    case modifier
    when Crystal::Visibility::Protected then :protected
    when Crystal::Visibility::Private   then :private
    else                                     :public
    end
  end

  def transform(node : Crystal::Expressions) : Crystal::ASTNode
    node.expressions.each do |exp|
      if match = exp.to_s.match(/^(property|getter|setter|property\?|getter\?)\((\w+) : ([\w:| ]+)\)/)
        visibility, name, type = match[1], match[2], match[3].gsub("::Nil", "Nil")

        Cruml::ClassList.find_by_name!(@current_class_name).tap do |class_info|
          class_info.add_instance_var("@#{name}", type)

          if ["property", "getter", "property?", "getter?"].includes?(visibility)
            class_info.add_method(Cruml::Entities::MethodInfo.new(:public, name, type))
          end

          if ["property", "setter", "property?", "getter?"].includes?(visibility)
            class_info.add_method(Cruml::Entities::MethodInfo.new(:public, "#{name}=", type))
          end
        end
      end
    end
    super(node)
  end

  def transform(node : Crystal::InstanceVar) : Crystal::ASTNode
    ivar_name = node.name.to_s

    @variables.each do |variable|
      var_name = variable.var.to_s
      var_type = variable.declared_type.to_s

      if var_name.includes?(ivar_name)
        if @current_module_name.empty?
          Cruml::ClassList.find_by_name!(@current_class_name).add_instance_var(var_name, var_type)
        else
          Cruml::ModuleList.find_by_name!(@current_module_name).add_instance_var(var_name, var_type)
        end
      end
    end

    super(node)
  end

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

  def transform(node : Crystal::TypeDeclaration) : Crystal::ASTNode
    @variables |= [node]
    super(node)
  end

  def transform(node : Crystal::Def) : Crystal::ASTNode
    is_not_duplicated_method = @protected_and_private_methods.none? do |method|
      method.name == node.name
    end

    node.args.each do |arg|
      arg_name = arg.name.to_s
      node.body.to_s.each_line do |line|
        if match = line.match(/^@(\w+) = #{arg_name}$/)
          ivar_name = match[1]
          Cruml::ClassList.find_by_name!(@current_class_name).add_instance_var("@#{ivar_name}", arg.restriction.to_s.gsub("::Nil", "Nil"))
        end
      end
    end

    if match = node.body.to_s.match(/^@(\w+) : ([\w:| ]+)$/)
      ivar_name, ivar_type = match[1], match[2].gsub("::Nil", "Nil")
      Cruml::ClassList.find_by_name!(@current_class_name).add_instance_var("@#{ivar_name}", ivar_type)
    end

    if is_not_duplicated_method
      return_type = node.return_type.to_s || "Nil"
      visibility = node.name.to_s == "initialize" ? :protected : :public
      method_name = node.receiver ? "self.#{node.name}" : node.name

      method_info = Cruml::Entities::MethodInfo.new(visibility, method_name, return_type)

      node.args.map(&.to_s).each do |arg|
        arg_name, arg_type = arg.split(" : ")
        method_info.add_arg(
          Cruml::Entities::ArgInfo.new(arg_name, arg_type.gsub(" ::", ' '))
        )
      end

      if @current_module_name.empty?
        # Add a method into class.
        Cruml::ClassList.find_by_name!(@current_class_name).add_method(method_info)
      else
        # Add a method into module.
        Cruml::ModuleList.find_by_name!(@current_module_name).add_method(method_info)
      end
    end

    super(node)
  end
end
