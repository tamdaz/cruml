# This consists of obtaining information about the reflected class.
class Cruml::Entities::ClassInfo
  getter name : String
  getter type : Symbol
  getter parent_classes : Array(Tuple(String, String, Symbol))
  getter included_modules : Array(String)
  getter instance_vars : Array(Tuple(String, String))
  getter methods : Array(Cruml::Entities::MethodInfo)

  def initialize(@name : String, @type : Symbol) : Nil
    @instance_vars = [] of Tuple(String, String)
    @parent_classes = [] of Tuple(String, String, Symbol)
    @included_modules = [] of String
    @methods = [] of Cruml::Entities::MethodInfo
  end

  # Adds the name and the type of a instance variable into the instance vars array.
  # ```
  # class_info = Cruml::Entities::ClassInfo.new("Person", :class)
  # class_info.add_instance_var("first_name", "String")
  # ```
  def add_instance_var(name : String, type : String) : Nil
    @instance_vars.reject! { |ivar| ivar[0] == name }
    @instance_vars << {name, type}
  end

  # Adds a parent class into an array of parent classes.
  # ```
  # class_info = Cruml::Entities::ClassInfo.new("Employee", :class)
  # class_info.add_parent_class("Person")
  # ```
  def add_parent_class(parent_class_name : String) : Nil
    found_class = Cruml::ClassList.find_by_name(parent_class_name)
    if found_class
      @parent_classes << {parent_class_name, @name, found_class.type}
    end
  end

  def add_included_module(module_name : String) : Nil
    @included_modules << module_name
  end

  # Adds a method into an array of methods.
  # INFO: The special `initialize` method will be placed at the first element of the list.
  # ```
  # class_info = Cruml::Entities::ClassInfo.new("Person", :class)
  # method_info = Cruml::Entities::MethodInfo.new(:public, "major?", "Bool")
  # class_info.add_method(method_info)
  # ```
  def add_method(method : Cruml::Entities::MethodInfo) : Nil
    if method.name == "initialize"
      @methods.unshift(method)
    else
      @methods << method
    end
  end
end
