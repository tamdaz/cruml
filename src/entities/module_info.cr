# This consists of obtaining information about module.
class Cruml::Entities::ModuleInfo
  getter name : String
  getter type : Symbol
  getter methods = [] of Cruml::Entities::MethodInfo
  getter instance_vars = [] of Tuple(String, String)

  def initialize(@name : String, @type : Symbol = :normal); end

  # Adds a method into module.
  def add_method(method : Cruml::Entities::MethodInfo) : Nil
    @methods << method
  end

  # Adds an instance var into module.
  def add_instance_var(name : String, type : String) : Nil
    @instance_vars.reject! { |ivar| ivar[0] == name }
    @instance_vars << {name, type}
  end
end
