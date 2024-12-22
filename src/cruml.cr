require "./annotations"
require "./diagram_render"
require "./reflection"
require "./entities/**"
require "./class_list"

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
  VERSION = "0.2.0"

  # Proceed to the UML diagram generation.
  def self.run : Nil
    class_list = Cruml::Reflection.start
    if class_list.classes.empty?
      puts "\e[31mCannot generate UML diagram because there's no selected classes. Abort.\e[0m"
      exit 1
    end

    diagram_render = Cruml::DiagramRender.new(Path[::CRUML_OUT_DIR])
    diagram_render.generate(class_list)
    diagram_render.save
  end
end
