# This consists of obtaining information about the reflected methods in a class.
class Cruml::Entities::MethodInfo
  # Scope of a method. This latter can be :public, :protected or :private.
  getter scope : Symbol

  # Name of a method.
  getter name : String

  # Return type of a method.
  getter return_type : String

  # The scope, name and return type of a method must be passed as parameters.
  # INFO: The special `initialize` method will be placed at the first element of the list.
  # ```
  # Cruml::Entities::MethodInfo.new(:public, "major?", "Bool")
  # ```
  def initialize(scope : Symbol, name : String, return_type : String)
    @scope = scope
    @name = name
    @return_type = return_type
  end
end
