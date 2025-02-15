# This consists of obtaining information about the reflected methods in a class.
class Cruml::Entities::MethodInfo
  # Scope of a method. This latter can be :public, :protected or :private.
  getter scope : Symbol

  # Name of a method.
  getter name : String

  # Return type of a method.
  getter return_type : String

  # List of arguments of a method.
  getter args : Array(Cruml::Entities::ArgInfo)

  # The scope, name and return type of a method must be passed as parameters.
  # INFO: The special `initialize` method will be placed at the first element of the list.
  # ```
  # Cruml::Entities::MethodInfo.new(:public, "major?", "Bool")
  # ```
  def initialize(scope : Symbol, name : String, return_type : String)
    @scope = scope
    @name = name
    @return_type = return_type
    @args = [] of Cruml::Entities::ArgInfo
  end

  # Add an argument into the args list.
  # ```
  # first_name_arg = Cruml::Entities::ArgInfo.new("first_name", "String")
  # last_name_arg = Cruml::Entities::ArgInfo.new("first_name", "String")
  #
  # full_name = Cruml::Entities::MethodInfo.new(:public, "full_name", "String")
  # full_name.add_arg(first_name_arg)
  # full_name.add_arg(last_name_arg)
  # ```
  def add_arg(arg : Cruml::Entities::ArgInfo)
    @args << arg
  end
end
