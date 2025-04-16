# This consists of obtaining information about argument name and type.
class Cruml::Entities::ArgInfo
  # Argument name
  getter name : String

  # Argument type
  getter type : String

  def initialize(@name : String, @type : String); end
end
