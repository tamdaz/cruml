class Cruml::Entities::MethodInfo
  getter name : String
  getter return_type : String

  def initialize(@name : String, @return_type : String); end
end
