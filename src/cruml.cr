require "./annotations"
require "./reflection"
require "./class_list"
require "./entities/**"
require "./renders/**"

# **cruml** *(**Cr**ystal **UML**)* is a library that allows to generate a UML diagram.
# This is useful for any Crystal projects.
#
# ```
# require "cruml"
#
# module Project
#   # your module containing classes of all types.
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
# > Cruml uses macros to retrieve reflected classes.
module Cruml
  VERSION = "0.3.0"

  # Proceed to the UML diagram generation.
  def self.run : Nil
    class_list = Cruml::Reflection.start
    if class_list.classes.empty?
      puts "\e[31mUnable to generate class diagram because no class is selected. Abort.\e[0m"
      exit 1
    end

    diagram_render = Cruml::DiagramRender.new(Path[::CRUML_OUT_DIR])
    diagram_render.generate(class_list)
    diagram_render.save
  end
end
