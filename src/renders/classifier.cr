module Cruml::Renders::Classifier
  private def add_normal_class(name : String, &) : Nil
    @code << Cruml::Renders::UML::INDENT * 3 << "class " << '`' << name << '`' << " {\n"
    yield
    @code << Cruml::Renders::UML::INDENT * 3 << "}\n"
  end

  private def add_abstract_class(name : String, &) : Nil
    @code << Cruml::Renders::UML::INDENT * 3 << "class " << '`' << name << '`' << ":::abstract {\n"
    @code << Cruml::Renders::UML::INDENT * 4 << "&lt;&lt;abstract&gt;&gt;\n"
    yield
    @code << Cruml::Renders::UML::INDENT * 3 << "}\n"
  end

  private def add_interface(name : String, &) : Nil
    @code << Cruml::Renders::UML::INDENT * 3 << "class " << '`' << name << '`' << ":::interface {\n"
    @code << Cruml::Renders::UML::INDENT * 4 << "&lt;&lt;interface&gt;&gt;\n"
    yield
    @code << Cruml::Renders::UML::INDENT * 3 << "}\n"
  end

  private def add_namespace(name : String, &) : Nil
    @code << Cruml::Renders::UML::INDENT * 2 << "namespace -" << name << " {\n"
    yield
    @code << Cruml::Renders::UML::INDENT * 2 << "}\n"
  end

  private def add_module(name : String, &)
    @code << Cruml::Renders::UML::INDENT * 3 << "class `" << name << "`:::module {\n"
    @code << Cruml::Renders::UML::INDENT * 4 << "&lt;&lt;module&gt;&gt;\n"
    yield
    @code << Cruml::Renders::UML::INDENT * 3 << "}\n"
  end

  private def add_interface(name : String, &)
    @code << Cruml::Renders::UML::INDENT * 3 << "class `" << name << "`:::interface {\n"
    @code << Cruml::Renders::UML::INDENT * 4 << "&lt;&lt;interface&gt;&gt;\n"
    yield
    @code << Cruml::Renders::UML::INDENT * 3 << "}\n"
  end
end
