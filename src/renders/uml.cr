require "./classifier"

# A module that provides methods to generate a Mermaid code.
module Cruml::Renders::UML
  include Cruml::Renders::Classifier

  # To format the mermaid code, an indentation of 4 spaces is set.
  INDENT = " " * 4

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
      # Replace `::` by `-`
      namespace = mod.name.gsub("::", '-').split('-')
      namespace.pop if namespace.size > 1

      ivars_and_methods = -> do
        add_instance_vars(mod.instance_vars)
        add_methods(mod.methods)
      end

      add_namespace namespace.join('-') do
        case mod.type
        when :normal    then add_module(mod.name, &ivars_and_methods)
        when :interface then add_interface(mod.name, &ivars_and_methods)
        end
      end
    end
  end

  # Generates class diagrams.
  private def generate_class_diagrams
    Cruml::ClassList.group_by_namespaces.each do |namespace, classes|
      # Add a relationship before creating a namespace.
      classes.each do |klass|
        add_parent_class(klass.parent_classes)
        klass.included_modules.each do |included_module|
          @code << INDENT * 2 << '`' << included_module << "` <|-- `" << klass.name << '`' << "\n"
        end
      end

      # Replace `::` by `.`
      add_namespace namespace.gsub("::", '.') do
        classes.each { |class_info| add_class(class_info) }
      end
    end
  end

  # Adds instance variables to the class.
  private def add_instance_vars(instance_vars : Array(Tuple(String, String))) : Nil
    instance_vars.each do |name, type|
      @code << INDENT * 4 << '-' << name << " : " << type << "\n"
    end
  end

  # Creates a class with a complete set of instance variables and methods.
  private def add_class(class_info : Cruml::Entities::ClassInfo) : Nil
    short_class_name = class_info.name

    ivars_and_methods = -> do
      add_instance_vars(class_info.instance_vars)
      add_methods(class_info.methods)
    end

    case class_info.type # begin class
    when :abstract  then add_abstract_class(short_class_name, &ivars_and_methods)
    when :interface then add_interface(short_class_name, &ivars_and_methods)
    when :class     then add_normal_class(short_class_name, &ivars_and_methods)
    end
  end

  # Adds methods to the class.
  private def add_methods(methods : Array(Cruml::Entities::MethodInfo)) : Nil
    methods.each do |method|
      visibility = method_visibility(method.visibility)

      @code << INDENT * 4 << visibility << method.name
      @code << '(' << method.generate_args << ')'
      if method.return_type =~ /\(.*\)/
        @code << " : "
      end
      @code << method.return_type
      @code << "\n"
    end
  end

  # Creates a link between parent and child classes.
  # If it is an interface, the arrow would look like : <|..
  # If the parent class type is normal or abstract, the arrow would look like : <|--
  # See https://mermaid.js.org/syntax/classDiagram.html#defining-relationship for more info.
  private def add_parent_class(inherit_classes : Array(Tuple(String, String, Symbol))) : Nil
    inherit_classes.each do |class_name, subclass_name, class_type|
      @code << INDENT * 2 << '`' << class_name << '`'

      @code << case class_type
      when :interface then " <|.. "
      when :class     then " <|-- "
      when :abstract  then " <|-- "
      end

      @code << "`" << subclass_name << '`' << "\n"
    end
  end

  # Defines the style properties for the class diagram.
  # See https://mermaid.js.org/syntax/classDiagram.html#default-class for more info.
  private def set_diagram_colors : Nil
    @code << Cruml::Renders::Config.class_def_colors
  end
end
