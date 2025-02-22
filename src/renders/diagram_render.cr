require "ecr"
require "./uml"

# Consists of generating a class diagram.
# See https://mermaid.js.org/syntax/classDiagram.html
class Cruml::Renders::DiagramRender
  include Cruml::Renders::UML

  getter code = String::Builder.new("classDiagram\n")

  def initialize(@path_dir : String); end

  # Generates the class diagram.
  def generate : Nil
    generate_module_diagrams
    generate_class_diagrams
    set_diagram_colors
  end

  # Saves the class diagram as an HTML file.
  def save : Nil
    output = ECR.render("src/renders/diagram.ecr")
    File.write(@path_dir, output)
  end
end
