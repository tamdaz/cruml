require "ecr"
require "./uml"

# Consists of generating a class diagram.
# See https://mermaid.js.org/syntax/classDiagram.html
class Cruml::Renders::DiagramRender
  include Cruml::Renders::UML

  @code = String::Builder.new("classDiagram\n")

  def initialize(@path_dir : String)
    Cruml::ModuleList.modules.each do |mod|
      @code << "namespace #{mod.name.gsub("::", '.').split('.').first} {\n"
      @code << "class #{mod.name.gsub("::", '.')}:::module {\n"
      @code << "&lt;&lt;module&gt;&gt;\n"
      add_instance_vars(mod.instance_vars)
      add_methods(mod.methods)
      @code << "}\n"
      @code << "}\n"
    end

    Cruml::ClassList.group_by_namespaces.each do |klass_group|
      namespace, classes = klass_group[0], klass_group[1]

      # Add a relationship before creating a namespace.
      classes.each do |klass|
        add_parent_class(klass.parent_classes)
        klass.included_modules.each do |included_module|
          @code << namespace + '.' if namespace
          @code << "#{included_module} <|-- #{klass.name}\n"
        end
      end

      @code << "namespace " << namespace << " {\n"        # begin namespace
      classes.each do |class_info|
        add_class(class_info)
      end
      @code << "}\n"                                      # end namespace
    end
    set_diagram_colors
  end

  # Creates a class with a whole set of instance variables and methods.
  # See https://mermaid.js.org/syntax/classDiagram.html#class for more info.
  private def add_class(class_info : Cruml::Entities::ClassInfo) : Nil
    short_class_name = class_info.name.split("::")[-1]

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

  # Define the style properties for the class diagram.
  # See https://mermaid.js.org/syntax/classDiagram.html#default-class for more info.
  private def set_diagram_colors : Nil
    @code << "classDef default fill:#2e1065,color:white\n"
    @code << "classDef abstract fill:#365314,color:white\n"
    @code << "classDef module fill:#0041cc,color:white"
  end

  # Save the class diagram as a HTML file.
  def save : Nil
    output = ECR.render("src/renders/diagram.ecr")
    File.write(@path_dir, output)
  end
end
