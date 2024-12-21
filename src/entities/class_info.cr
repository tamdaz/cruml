require "./method_info"

class Cruml::Entities::ClassInfo
  getter name : String
  getter type : Symbol
  getter inherit_classes : Array(Tuple(String, String, Symbol))
  getter instance_vars : Array(Tuple(String, String))
  getter methods : Array(Cruml::Entities::MethodInfo)

  def initialize(@name : String, @type : Symbol) : Nil
    @instance_vars = [] of Tuple(String, String)
    @inherit_classes = [] of Tuple(String, String, Symbol)
    @methods = [] of Cruml::Entities::MethodInfo
  end

  def add_instance_var(name : String, type : String) : Nil
    @instance_vars << {name, type}
  end

  def add_inherit_class(parent_class_name : String, inherit_class_name : String) : Nil
    @inherit_classes << {parent_class_name, inherit_class_name, @type}
  end

  def add_method(method : Cruml::Entities::MethodInfo) : Nil
    @methods << method
  end
end
