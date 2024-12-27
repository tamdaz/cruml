# This consists of obtaining information about the reflected arguments.
class Cruml::Entities::ArgsInfo
  # Argument name.
  getter name : String

  # Argument type.
  getter type : String

  # Argument name and type must be passed as parameters.
  # ```
  # Cruml::Entities::ArgsInfo.new("first_name", "String")
  # Cruml::Entities::ArgsInfo.new("last_name", "String")
  # Cruml::Entities::ArgsInfo.new("age", "Int32")
  # ```
  def initialize(name : String, type : String)
    @name = name
    @type = type
  end
end
