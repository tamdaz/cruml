module Cruml::Renders::Classifier
  private def add_normal_class(name : String, &) : Nil
    @code << '"' << name << '"' << " {\n"
    @code << Cruml::Renders::UML::INDENT << "shape: class\n"
    unless Cruml::Renders::Config.no_color?
      @code << Cruml::Renders::UML::INDENT << <<-STR
      style.fill: "#{Cruml::Renders::Config.class_color}"\n
      STR
    end
    yield
    @code << "}\n"
  end

  private def add_abstract_class(name : String, &) : Nil
    @code << Cruml::Renders::UML::INDENT * 3 << '"' << name << '"' << " {\n"
    @code << Cruml::Renders::UML::INDENT << "shape: class\n"
    unless Cruml::Renders::Config.no_color?
      @code << Cruml::Renders::UML::INDENT << <<-STR
      style.fill: "#{Cruml::Renders::Config.abstract_color}"\n
      STR
    end
    yield
    @code << Cruml::Renders::UML::INDENT * 3 << "}\n"
  end

  private def add_interface(name : String, &) : Nil
    @code << Cruml::Renders::UML::INDENT * 3 << '"' << name << '"' << " {\n"
    @code << Cruml::Renders::UML::INDENT << "shape: class\n"
    unless Cruml::Renders::Config.no_color?
      @code << Cruml::Renders::UML::INDENT << <<-STR
      style.fill: "#{Cruml::Renders::Config.interface_color}"\n
      STR
    end
    yield
    @code << Cruml::Renders::UML::INDENT * 3 << "}\n"
  end

  private def add_namespace(name : String, &) : Nil
    @code << '"' << name << '"' << " {\n"
    yield
    @code << "}\n"
  end

  private def add_module(name : String, &)
    @code << Cruml::Renders::UML::INDENT << '"' << name << '"' << " {\n"
    @code << Cruml::Renders::UML::INDENT << "shape: class\n"
    yield
    @code << Cruml::Renders::UML::INDENT << "}\n"
  end
end
