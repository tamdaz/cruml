# This consists of obtaining information about the reflected class.
class Cruml::Entities::ClassInfo
  # Name of a class.
  getter name : String

  # Type of a class. This latter can be set as :class, :abstract or :interface.
  getter type : Symbol

  # A list of inherited classes.
  getter inherit_classes : Array(Tuple(String, String, Symbol))

  # A list of instance variables.
  getter instance_vars : Array(Tuple(String, String))

  # A list of methods.
  getter methods : Array(Cruml::Entities::MethodInfo)

  # The name and type of a class will be passed as arguments.
  # A list of instance variables, inherited classes and methods are empty
  # when the `Cruml::Entities::ClassInfo` class is instantiated.
  # ```
  # Cruml::Entities::ClassInfo.new("Person", :class)
  # ```
  def initialize(@name : String, @type : Symbol) : Nil
    @instance_vars = [] of Tuple(String, String)
    @inherit_classes = [] of Tuple(String, String, Symbol)
    @methods = [] of Cruml::Entities::MethodInfo
  end

  # Adds the name and the type of a instance variable into the instance vars array.
  # ```
  # class_info = Cruml::Entities::ClassInfo.new("Person", :class)
  # class_info.add_instance_var("first_name", "String")
  # ```
  def add_instance_var(name : String, type : String) : Nil
    @instance_vars << {name, type}
  end

  # Adds a inherited class into a list of inherited classes.
  # ```
  # class_info = Cruml::Entities::ClassInfo.new("Person", :class)
  # class_info.add_inherit_class("Person", "Employee")
  # ```
  def add_inherit_class(parent_class_name : String, inherit_class_name : String) : Nil
    @inherit_classes << {parent_class_name, inherit_class_name, @type}
  end

  # Adds a method into a list of methods.
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
