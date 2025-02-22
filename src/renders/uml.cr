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

  # Generates module diagrams.
  private def generate_module_diagrams
    Cruml::ModuleList.modules.each do |mod|
      @code << "namespace #{mod.name.gsub("::", '.').split('.').first} {\n"
      @code << "class #{mod.name.gsub("::", '.')}:::module {\n"
      @code << "&lt;&lt;module&gt;&gt;\n"
      add_instance_vars(mod.instance_vars)
      add_methods(mod.methods)
      @code << "}\n"
      @code << "}\n"
    end
  end

  # Generates class diagrams.
  private def generate_class_diagrams
    Cruml::ClassList.group_by_namespaces.each do |klass_group|
      namespace, classes = klass_group[0], klass_group[1]

      # Add a relationship before creating a namespace.
      classes.each do |klass|
        add_parent_class(klass.parent_classes)
        klass.included_modules.each do |included_module|
          @code << namespace.gsub("::", '.') + '.' if namespace
          @code << "#{included_module.gsub("::", '.')} <|-- #{klass.name.gsub("::", '.')}\n"
        end
      end

      @code << "namespace " << namespace.gsub("::", '.') << " {\n"
      classes.each do |class_info|
        add_class(class_info)
      end
      @code << "}\n"
    end
  end

  # Adds instance variables to the class.
  private def add_instance_vars(instance_vars : Array(Tuple(String, String))) : Nil
    instance_vars.each do |ivar|
      name, type = ivar[-2], ivar[-1]
      @code << "    -#{name} : #{type}\n"
    end
  end

  # Creates a class with a complete set of instance variables and methods.
  private def add_class(class_info : Cruml::Entities::ClassInfo) : Nil
    short_class_name = class_info.name.gsub("::", '.')

    case class_info.type # begin class
    when :abstract
      @code << "  class #{short_class_name}:::abstract {\n"
      @code << "    &lt;&lt;abstract&gt;&gt;\n"
    when :class
      @code << "  class #{short_class_name} {\n"
    end

    add_instance_vars(class_info.instance_vars)
    add_methods(class_info.methods)

    @code << "  }\n" # end class
  end

  # Adds methods to the class.
  private def add_methods(methods : Array(Cruml::Entities::MethodInfo)) : Nil
    methods.each do |method|
      visibility = method_visibility(method.visibility)

      @code << "    #{visibility}#{method.name}(#{method.generate_args}) "
      @code << " : " if method.return_type =~ /\(.*\)/
      @code << "#{method.return_type}\n"
    end
  end

  # Creates a link between parent and child classes.
  # If the parent class type is abstract, the arrow would look like : <|..
  # If the parent class type is normal, the arrow would look like : <|--
  # See https://mermaid.js.org/syntax/classDiagram.html#defining-relationship for more info.
  private def add_parent_class(inherit_classes : Array(Tuple(String, String, Symbol))) : Nil
    inherit_classes.each do |class_name, subclass_name, class_type|
      case class_type
      when :abstract
        @code << "#{class_name.gsub("::", '.')} <|.. #{subclass_name.gsub("::", '.')}\n"
      when :class
        @code << "#{class_name.gsub("::", '.')} <|-- #{subclass_name.gsub("::", '.')}\n"
      end
    end
  end

  # Defines the style properties for the class diagram.
  # See https://mermaid.js.org/syntax/classDiagram.html#default-class for more info.
  private def set_diagram_colors : Nil
    @code << Cruml::Renders::Config.class_def_colors
  end
end
