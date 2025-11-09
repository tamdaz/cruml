# Centralized regex patterns for parsing Crystal code
module Cruml::Parsers::RegexPatterns
  # Matches include statements: include MyModule
  INCLUDE = /^include (\w+(?:::\w+)*)$/

  # Matches extend statements: extend MyModule
  EXTEND = /^extend (\w+(?:::\w+)*)$/

  # Matches class variable attributes: `class_getter(name : Type)`
  CLASS_VARS_ATTRIBUTE = /(class_getter|class_property|class_setter)\((\w+) : (\w+)\)/

  # Matches instance variable attributes: `property(name : Type)`
  INSTANCE_VARS_ATTRIBUTE = /^(property|getter|setter|property\?|getter\?)\((\w+) : ([\w:| ]+)\)/

  # Matches instance variable declarations: `@name : Type`
  INSTANCE_VARS = /^@(\w+) : ([\w:| ()]+)$/

  # Matches instance variable assignment in initialize: `@name = arg_name`
  INSTANCE_VAR_ASSIGNMENT = /^@(\w+) = (\w+)$/

  # Helper methods for checking property visibility types
  module VisibilityHelpers
    def self.has_getter?(visibility : String) : Bool
      %w[property getter property? getter?].includes?(visibility)
    end

    def self.has_setter?(visibility : String) : Bool
      %w[property setter property?].includes?(visibility)
    end

    def self.has_class_getter?(visibility : String) : Bool
      %w[class_property class_getter class_property? class_getter?].includes?(visibility)
    end

    def self.has_class_setter?(visibility : String) : Bool
      %w[class_property class_setter class_property?].includes?(visibility)
    end
  end
end
