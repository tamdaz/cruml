class Cruml::Entities::MethodInfo
  getter scope : Symbol
  getter name : String
  getter return_type : String

  def initialize(@scope : Symbol, @name : String, @return_type : String); end
end
