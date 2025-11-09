require "ecr"
require "file_utils"
require "./uml"

# Consists of generating a class diagram (see https://d2lang.com/tour/uml-classes)
class Cruml::Renders::DiagramRender
  include Cruml::Renders::UML

  getter code = String::Builder.new

  def initialize(@path_dir : String, @registry : Cruml::Services::RegistryService); end

  # Generates the UML class diagram.
  def generate : Nil
    generate_diagrams_by_namespace
    generate_standalone_modules
    generate_standalone_classes
  end

  # Saves the class diagram as a `.d2` file.
  def save : Nil
    dir = File.dirname(@path_dir)
    FileUtils.mkdir_p(dir) unless Dir.exists?(dir)
    File.write(@path_dir, code.to_s)
  rescue error : File::AccessDeniedError
    puts "An error is occured when saving the diagram into #{@path_dir}. Please retry.".colorize(:red)
    puts ("Reason of this error : " + error.to_s).colorize(:red)
  end
end
