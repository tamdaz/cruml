require "compiler/crystal/syntax"
require "./class_list"

class Cruml::Transformer < Crystal::Transformer
  def initialize
    @current_class_name = ""
    @visibility = :public
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
    @visibility = visibility(node.modifier)
    super(node)
  end

  private def visibility(modifier : Crystal::Visibility) : Symbol
    case modifier
    when Crystal::Visibility::Protected then :protected
    when Crystal::Visibility::Private   then :private
    else                                     :public
    end
  end

  # @[Deprecated]
  # def transform(node : Crystal::InstanceVar) : Crystal::ASTNode
  #   Cruml::ClassList.find_by_name(@current_class_name).add_instance_var(node.name, "String")
  #   super(node)
  # end

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

  def transform(node : Crystal::Def) : Crystal::ASTNode
    return_type = node.return_type.to_s || "Nil"
    method_info = if node.name.to_s == "initialize"
                    Cruml::Entities::MethodInfo.new(:protected, node.name.to_s, "Nil")
                  else
                    Cruml::Entities::MethodInfo.new(@visibility, node.name.to_s, return_type)
                  end

    node.args.map(&.to_s).each do |arg|
      arg_name_type = arg.split(" : ")
      method_info.add_arg(Cruml::Entities::ArgInfo.new(arg_name_type[0], arg_name_type[1].gsub("::Nil", "Nil")))
    end

    Cruml::ClassList.find_by_name(@current_class_name).add_method(method_info)
    super(node)
  end
end
