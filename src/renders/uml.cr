module Cruml::Renders::UML
  # Gets the UML method visibility.
  private def method_visibility(visibility : Symbol) : Char
    case visibility
    when :public    then '+'
    when :protected then '#'
    when :private   then '-'
    else                 '?'
    end
  end

  # Add the instance vars into class.
  private def add_instance_vars(instance_vars : Array(Tuple(String, String))) : Nil
    instance_vars.each do |ivar|
      name, type = ivar[-2], ivar[-1]
      @code << "    -#{name} : #{type}\n"
    end
  end

  private def add_methods(methods : Array(Cruml::Entities::MethodInfo)) : Nil
    methods.each do |method|
      visibility = method_visibility(method.visibility)

      @code << "    #{visibility}#{method.name}(#{method.generate_args}) "
      @code << " : " if method.return_type =~ /\(.*\)/
      @code << "#{method.return_type}\n"
    end
  end

  # Creates a link between the parent and child classes.
  # If the parent class type is abstract, the arrow would look like : <|..
  # If the parent class type is normal, the arrow would look like : <|--
  # See https://mermaid.js.org/syntax/classDiagram.html#defining-relationship for more info.
  private def add_parent_class(inherit_classes : Array(Tuple(String, String, Symbol))) : Nil
    inherit_classes.each do |class_name, subclass_name, class_type|
      case class_type
      when :abstract
        @code << "#{class_name.split("::")[-1]} <|.. #{subclass_name.split("::")[-1]}\n"
      when :class
        @code << "#{class_name.split("::")[-1]} <|-- #{subclass_name.split("::")[-1]}\n"
      end
    end
  end
end
