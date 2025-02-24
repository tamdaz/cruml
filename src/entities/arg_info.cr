# This consists of obtaining information about argument name and type.
class Cruml::Entities::ArgInfo
  getter name : String
  getter type : String

  def initialize(@name : String, @type : String); end
end
