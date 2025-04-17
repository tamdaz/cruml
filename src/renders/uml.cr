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
      ivars_and_methods = -> do
        add_instance_vars(mod.instance_vars)
        add_methods(mod.methods)
      end

      case mod.type
      when :normal    then add_module(mod.name, &ivars_and_methods)
      when :interface then add_interface(mod.name, &ivars_and_methods)
      end
    end
  end

  # Generates class diagrams.
  private def generate_class_diagrams
    Cruml::ClassList.group_by_namespaces.each do |namespace, classes|
      add_namespace(namespace) do
      classes.each do |klass|
        add_class(klass)
        add_parent_class(klass.parent_classes)
      end
    end
  end

    Cruml::ClassList.classes.each do |klass|
      add_class(klass)
      add_parent_class(klass.parent_classes)
    end
  end

  # Adds instance variables to the class.
  private def add_instance_vars(instance_vars : Array(Tuple(String, String))) : Nil
    instance_vars.each do |name, type|
      @code << INDENT << '-' << name << " : " << type << "\n"
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

      # Escape the '#' char if protected (for d2).
      visibility = "\\#" if visibility == '#'

      @code << INDENT << visibility << method.name << '(' << method.generate_args << ')'

      unless method.return_type.empty?
        @code << ": " << method.return_type
      end

      @code << "\n"
    end
  end

  # Creates a link between parent and child classes.
  private def add_parent_class(inherit_classes : Array(Tuple(String, String, Symbol))) : Nil
    inherit_classes.each do |class_name, subclass_name, _class_type|
      @code << class_name.dump << " -> " << subclass_name.dump << "\n"
    end
  end

  # Defines the style properties for the class diagram.
  private def set_diagram_colors : Nil
    @code << Cruml::Renders::Config.class_def_colors
  end
end
