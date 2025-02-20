# This consists of obtaining information about the reflected arguments.
class Cruml::Entities::ArgInfo
  # Argument name.
  getter name : String

  # Argument type.
  getter type : String

  # Argument name and type must be passed as parameters.
  # ```
  # Cruml::Entities::ArgInfo.new("first_name", "String")
  # Cruml::Entities::ArgInfo.new("last_name", "String")
  # Cruml::Entities::ArgInfo.new("age", "Int32")
  # ```
  def initialize(name : String, type : String)
    @name = name
    @type = type
  end
end
