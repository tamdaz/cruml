# Classifiers consists to add classes, abstract classes, interfaces, modules and
# namespaces into the class diagram.
module Cruml::Renders::Classifier
  # Adds an object into the class diagram.
  private def add_object(name : String, color : String) : Nil
    @code << '"' << name << '"' << " {\n"
    @code << Cruml::Renders::UML::INDENT << "shape: class\n"
    unless Cruml::Renders::Config.no_color?
      @code << Cruml::Renders::UML::INDENT << <<-STR
      style.fill: "#{color}"\n
      STR
    end
    yield
    @code << "}\n"
  end

  # Adds a normal class into the class diagram.
  private def add_normal_class(name : String, &) : Nil
    add_object(name, Cruml::Renders::Config.class_color) do
      yield
    end
  end

  # Adds an abstract class into the class diagram.
  private def add_abstract_class(name : String, &) : Nil
    add_object(name, Cruml::Renders::Config.abstract_color) do
      yield
    end
  end

  # Adds an interface into the class diagram.
  private def add_interface(name : String, &) : Nil
    add_object(name, Cruml::Renders::Config.interface_color) do
      yield
    end
  end

  # Adds a namespace into the class diagram.
  private def add_namespace(name : String, &) : Nil
    @code << '"' << name << '"' << " {\n"
    yield
    @code << "}\n"
  end

  # Adds a module into the class diagram.
  private def add_module(name : String, &)
    add_object(name, Cruml::Renders::Config.class_color) do
      yield
    end
  end
end
