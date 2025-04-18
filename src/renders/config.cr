require "yaml"

# Stores the diagram configuration.
class Cruml::Renders::Config
  # The theme of the diagram (`:light` or `:dark`).
  class_property theme : Symbol = :light

  # Whether to disable colors in the diagram.
  class_property? no_color : Bool = false

  # Enable the verbose mode
  class_property? verbose : Bool = false

  # Gets the color for classes.
  def self.class_color : String
    customized_color = color_theme_from_yaml("classes")

    if !customized_color.nil?
      customized_color
    else
      (@@theme == :light) ? "#baa7e5" : "#2e1065"
    end
  end

  # Gets the color for abstract classes.
  def self.abstract_color : String
    customized_color = color_theme_from_yaml("abstract_classes")

    if !customized_color.nil?
      customized_color
    else
      (@@theme == :light) ? "#a7e5a7" : "#365314"
    end
  end

  # Gets the color for interfaces.
  def self.interface_color : String
    customized_color = color_theme_from_yaml("interfaces")

    if !customized_color.nil?
      customized_color
    else
      (@@theme == :light) ? "#e2c7a3" : "#af6300"
    end
  end

  # Gets the color for modules.
  def self.module_color : String
    customized_color = color_theme_from_yaml("modules")

    if !customized_color.nil?
      customized_color
    else
      (@@theme == :light) ? "#5ab3f4" : "#0041cc"
    end
  end

  # Gets the theme color.
  def self.theme_color : String
    (@@theme == :light) ? "#dedede" : "#212121"
  end

  # Gets the text color.
  def self.text_color : String
    (@@theme == :light) ? "#000000" : "#ffffff"
  end

  # Retrieve the color from the YAML file.
  def self.color_theme_from_yaml(type : String) : String?
    File.open(Dir.current + "/.cruml.yml") do |file|
      colors = YAML.parse(file)["colors"]?

      if colors
        colors.as_h[@@theme.to_s][type].as_s
      end
    end
  end

  # Generates the class definitions for the diagram.
  def self.class_def_colors : String
    String.build do |io|
      [
        {:default, self.class_color},
        {:abstract, self.abstract_color},
        {:interface, self.interface_color},
        {:module, self.module_color},
      ].each do |type, color|
        io << Cruml::Renders::UML::INDENT * 2
        io << "classDef " << type << " fill:"
        io << (@@no_color == true ? self.theme_color : color)
        io << ",color:" << self.text_color
        io << ",stroke:" << (@@theme == :dark ? "#fff" : "#000")
        io << "\n"
      end
    end
  end
end
