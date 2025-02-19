require "compiler/crystal/syntax"
require "./class_list"

class Cruml::Transformer < Crystal::Transformer
  def initialize
    @current_class_name = ""
    @variables = [] of Crystal::TypeDeclaration
    @protected_and_private_methods = [] of Crystal::Def
  end

  def transform(node : Crystal::ClassDef) : Crystal::ASTNode
    @current_class_name = node.name.to_s.gsub("::", ".")

    if node.type_vars
      generic = node.type_vars.as(Array(String))
      @current_class_name += "~#{generic.join(", ")}~"
    end

    class_type = node.abstract? ? :abstract : :class
    class_info = Cruml::Entities::ClassInfo.new(@current_class_name, class_type)

    if node.superclass
      class_info.add_inherit_class(node.superclass.to_s.gsub("::", "."))
    end

    Cruml::ClassList.add(class_info)
    super(node)
  end

  def transform(node : Crystal::VisibilityModifier) : Crystal::ASTNode
    method = node.exp.as(Crystal::Def)
    @protected_and_private_methods << method
    Cruml::ClassList.find_by_name(@current_class_name).add_method(
      Cruml::Entities::MethodInfo.new(visibility(node.modifier), method.name.to_s, method.return_type.to_s)
    )
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

        Cruml::ClassList.find_by_name(@current_class_name).tap do |class_info|
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
        Cruml::ClassList.find_by_name(@current_class_name).add_instance_var(var_name, var_type)
      end
    end

    super(node)
  end

  def transform(node : Crystal::Assign) : Crystal::ASTNode
    @variables.each do |var|
      if node.target.to_s.includes?(var.var.to_s)
        Cruml::ClassList.find_by_name(@current_class_name).add_instance_var(node.target.to_s, var.declared_type.to_s.gsub(" ::", ' '))
      end
    end

    super(node)
  end

  def transform(node : Crystal::TypeDeclaration) : Crystal::ASTNode
    @variables |= [node]
    super(node)
  end

  def transform(node : Crystal::Def) : Crystal::ASTNode
    is_duplicated_method = @protected_and_private_methods.none? do |method|
      method.name == node.name
    end

    node.args.each do |arg|
      arg_name = arg.name.to_s
      node.body.to_s.each_line do |line|
        if match = line.match(/^@(\w+) = #{arg_name}$/)
          ivar_name = match[1]
          Cruml::ClassList.find_by_name(@current_class_name).add_instance_var("@#{ivar_name}", arg.restriction.to_s.gsub("::Nil", "Nil"))
        end
      end
    end

    if match = node.body.to_s.match(/^@(\w+) : ([\w:| ]+)$/)
      ivar_name, ivar_type = match[1], match[2].gsub("::Nil", "Nil")
      Cruml::ClassList.find_by_name(@current_class_name).add_instance_var("@#{ivar_name}", ivar_type)
    end

    if is_duplicated_method
      return_type = node.return_type.to_s || "Nil"
      visibility = node.name.to_s == "initialize" ? :protected : :public
      method_info = Cruml::Entities::MethodInfo.new(visibility, node.name.to_s, return_type)

      node.args.map(&.to_s).each do |arg|
        arg_name_type = arg.split(" : ")
        method_info.add_arg(
          Cruml::Entities::ArgInfo.new(arg_name_type[0], arg_name_type[1].gsub(" ::", ' '))
        )
      end

      Cruml::ClassList.find_by_name(@current_class_name).add_method(method_info)
    end

    super(node)
  end
end
