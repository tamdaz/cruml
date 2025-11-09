require "./regex_patterns"

# Parses variable declarations from Crystal code
module Cruml::Parsers::VariableParser
  extend self
  include Cruml::Parsers::RegexPatterns

  # Parses instance variable attributes like property, getter, setter
  def parse_instance_attribute(expression_string : String) : NamedTuple(visibility: String, name: String, type: String)?
    if match = expression_string.match(INSTANCE_VARS_ATTRIBUTE)
      {
        visibility: match[1],
        name:       match[2],
        type:       match[3],
      }
    end
  end

  # Parses class variable attributes like class_property, class_getter
  def parse_class_attribute(body_string : String) : NamedTuple(visibility: String, name: String, type: String)?
    if match = body_string.match(CLASS_VARS_ATTRIBUTE)
      {
        visibility: match[1],
        name:       match[2],
        type:       match[3],
      }
    end
  end

  # Parses instance variable declarations like @name : Type
  def parse_instance_var_declaration(line : String) : NamedTuple(name: String, type: String)?
    if match = line.match(INSTANCE_VARS)
      {
        name: match[1],
        type: match[2],
      }
    end
  end

  # Parses instance variable assignment in constructor like @name = arg_name
  def parse_instance_var_assignment(line : String, arg_name : String) : String?
    if match = line.match(INSTANCE_VAR_ASSIGNMENT)
      ivar_name = match[1]
      assignment_arg = match[2]

      if assignment_arg == arg_name
        return ivar_name
      end
    end

    nil
  end

  # Checks if the variable name matches the instance variable
  def matches_instance_var?(var_name : String, ivar_name : String) : Bool
    var_name.includes?(ivar_name)
  end
end
