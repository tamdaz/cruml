# This consists of obtaining information about module.
class Cruml::Entities::ModuleInfo
  getter name : String
  getter type : Symbol
  getter methods : Array(Cruml::Entities::MethodInfo)
  getter instance_vars : Array(Tuple(String, String))

  def initialize(@name : String, @type : Symbol = :normal)
    @methods = [] of Cruml::Entities::MethodInfo
    @instance_vars = [] of Tuple(String, String)
  end

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
