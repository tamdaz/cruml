require "../entities/method_info"
require "../entities/arg_info"

# Parses method definitions from Crystal AST nodes
module Cruml::Parsers::MethodParser
  extend self

  # Extracts arguments from a method definition and adds them to the MethodInfo
  def add_arguments(node : Crystal::Def, method : Cruml::Entities::MethodInfo) : Void
    node.args.each do |arg|
      arg_string = arg.to_s
      next unless arg_string.includes?(" : ")

      arg_name, arg_type = arg_string.split(" : ", 2)

      # Clean up namespace separators for better display
      arg_type = arg_type.gsub(" ::", ' ')

      method.add_arg(Cruml::Entities::ArgInfo.new(arg_name, arg_type))
    end
  end

  # Determines method visibility based on method name and modifier
  def determine_visibility(method_name : String, modifier : Crystal::Visibility? = nil) : Symbol
    return visibility_from_modifier(modifier) if modifier

    # Constructor methods are protected by convention
    method_name == "initialize" ? :protected : :public
  end

  # Converts Crystal visibility modifier to symbol
  def visibility_from_modifier(modifier : Crystal::Visibility) : Symbol
    case modifier
    when Crystal::Visibility::Protected then :protected
    when Crystal::Visibility::Private   then :private
    else                                     :public
    end
  end

  # Formats method name (handles class methods with self receiver)
  def format_method_name(node : Crystal::Def) : String
    node.receiver ? "self.#{node.name}" : node.name.to_s
  end

  # Gets return type or defaults to Nil
  def get_return_type(node : Crystal::Def) : String
    node.return_type.to_s.presence || "Nil"
  end
end
