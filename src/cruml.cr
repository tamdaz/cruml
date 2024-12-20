require "./annotations"
require "./diagram_render"
require "./reflector"

# **cruml** *(**Cr**ystal **UML**)* is a library that allows to generate a UML diagram.
# This is useful for any Crystal projects.
#
# ```
# require "cruml"
#
# module Project
#   # ...
# end
#
# # Your project module (e.g: Project)
# ::CRUML_FILTER_PREFIX = "Project"
#
# # Directory where the diagram will be saved.
# ::CRUML_OUT_DIR = "./out/"
#
# Cruml.run
# ```
# Cruml uses macros to retrieve the names of classes and the names and types of instance variables and methods.
module Cruml
  VERSION = "0.1.0"

  alias ClassArray = Array(Tuple(String, Symbol))
  alias LinkSubClassArray = Array(Tuple(String, String, Symbol))
  alias InstanceVarsArray = Array(Tuple(String, String))
  alias MethodsArray = Array(Tuple(Symbol, String, String))

  # Proceed to the UML diagram generation.
  def self.run : Nil
    reflected_classes = Cruml::Reflector.reflect_classes
    reflected_link_subclasses = Cruml::Reflector.reflect_link_subclasses
    reflected_instance_vars = Cruml::Reflector.reflect_instance_vars
    reflected_methods = Cruml::Reflector.reflect_methods

    if reflected_classes.empty?
      puts "\e[31mCannot generate a UML diagram because there's no selected classes. Abort.\e[0m"
      exit 1
    end

    diagram_render = Cruml::DiagramRender.new(Path[::CRUML_OUT_DIR])
    diagram_render.generate(
      reflected_classes, reflected_link_subclasses, reflected_instance_vars, reflected_methods
    )
    diagram_render.save
  end
end
