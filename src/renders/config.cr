# Stores the diagram configuration.
class Cruml::Renders::Config
  # The theme of the diagram (`:light` or `:dark`).
  class_property theme : Symbol = :light

  # Whether to disable colors in the diagram.
  class_property? no_color : Bool = false

  # Gets the color for classes.
  def self.class_color : String
    @@theme == :light ? "#baa7e5" : "#2e1065"
  end

  # Gets the color for abstract classes.
  def self.abstract_color : String
    @@theme == :light ? "#a7e5a7" : "#365314"
  end

  # Gets the color for interfaces.
  def self.interface_color : String
    @@theme == :light ? "#e2c7a3" : "#af6300"
  end

  # Gets the color for modules.
  def self.module_color : String
    @@theme == :light ? "#5ab3f4" : "#0041cc"
  end

  # Gets the theme color.
  def self.theme_color : String
    @@theme == :light ? "#dedede" : "#212121"
  end

  # Gets the text color.
  def self.text_color : String
    @@theme == :light ? "#000000" : "#ffffff"
  end

  # Generates the class definitions for the diagram.
  def self.class_def_colors : String
    String.build do |io|
      [
        {:default, self.class_color},
        {:abstract, self.abstract_color},
        {:interface, self.interface_color},
        {:module, self.module_color}
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
