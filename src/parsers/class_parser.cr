require "./regex_patterns"

# Parses class-specific information from Crystal AST
module Cruml::Parsers::ClassParser
  extend self
  include Cruml::Parsers::RegexPatterns

  # Determines the class type (interface, abstract, or normal class)
  def determine_class_type(class_name : String, node : Crystal::ClassDef) : Symbol
    if class_name.downcase.ends_with?("interface")
      :interface
    else
      node.abstract? ? :abstract : :class
    end
  end

  # Extracts generic type parameters from a class definition
  def extract_generics(node : Crystal::ClassDef) : String?
    if type_vars = node.type_vars
      generic = type_vars.as(Array(String))

      if generic
        "(#{generic.join(", ")})"
      end
    end
  end

  # Parses include statements from the class body
  def parse_includes(body_string : String) : Array(String)
    includes = [] of String

    body_string.each_line do |line|
      if match = line.match(INCLUDE)
        includes << match[1]
      end
    end

    includes
  end

  # Parses extend statements from the class body
  def parse_extends(body_string : String) : Array(String)
    extends = [] of String

    body_string.each_line do |line|
      if match = line.match(EXTEND)
        extends << match[1]
      end
    end

    extends
  end

  # Determines if a class name represents an interface
  def interface?(name : String) : Bool
    name.downcase.ends_with?("interface")
  end
end
