require "./annotations"
require "./diagram_render"
require "./reflector"
require "./../examples/**"

::CRUML_FILTER_PREFIX = "Example"

# TODO: Write documentation for `Cruml`
module Cruml
  VERSION = "0.1.0"

  alias ClassArray = Array(String)
  alias InstanceVarsArray = Array(Tuple(String, String))
  alias MethodsArray = Array(Tuple(Symbol, String, String))

  # Proceed to the UML diagram generation.
  def self.run : Nil
    reflected_classes = Cruml::Reflector.reflect_classes
    reflected_instance_vars = Cruml::Reflector.reflect_instance_vars
    reflected_methods = Cruml::Reflector.reflect_methods

    pp! reflected_classes.size
    pp! reflected_instance_vars.size
    pp! reflected_methods.size

    if reflected_classes.empty?
      puts "\e[31mCannot generate a UML diagram because there's no selected classes. Abort.\e[0m"
      exit 1
    end

    diagram_render = Cruml::DiagramRender.new(Path["out"])
    diagram_render.generate(reflected_classes, reflected_instance_vars, reflected_methods)
    diagram_render.save
  end

  run
end
