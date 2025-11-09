# This consists of obtaining information about the class.
class Cruml::Entities::ClassInfo
  # Class name
  getter name : String

  # Class type
  getter type : Symbol

  # Linked parent classes.
  getter parent_classes = [] of Tuple(String, String, Symbol)

  # Included modules in a class (instance methods).
  getter included_modules = [] of String

  # Extended modules in a class (class methods).
  getter extended_modules = [] of String

  # All instance variables in a class.
  getter instance_vars = [] of Tuple(String, String)

  # All class variables in a class.
  getter class_vars = [] of Tuple(String, String)

  # All methods in a class.
  getter methods = [] of Cruml::Entities::MethodInfo

  def initialize(@name : String, @type : Symbol); end

  # Adds the name and the type of a instance variable into the instance vars array.
  def add_instance_var(name : String, type : String) : Nil
    @instance_vars.reject! { |ivar| ivar[0] == name }
    @instance_vars << {name, type}

    if Cruml::Renders::Config.verbose?
      puts "VERBOSE : #{@name.colorize(:magenta)} instance var added to #{@name.colorize(:magenta)} class."
    end
  end

  # Adds the name and the type of a class variable into the class vars array.
  def add_class_var(name : String, type : String) : Nil
    @class_vars.reject! { |cvar| cvar[0] == name }
    @class_vars << {name, type}

    if Cruml::Renders::Config.verbose?
      puts "VERBOSE : #{@name.colorize(:magenta)} class var added to #{@name.colorize(:magenta)} class."
    end
  end

  # Adds a parent class into an array of parent classes.
  # The parent_type parameter allows specifying the type without needing ClassList.
  def add_parent_class(parent_class_name : String, parent_type : Symbol = :class) : Nil
    @parent_classes << {parent_class_name, @name, parent_type}

    if Cruml::Renders::Config.verbose?
      puts "VERBOSE : #{@name.colorize(:magenta)} child class linked to #{parent_class_name.colorize(:magenta)} parent class."
    end
  end

  # Adds a module name to the list of included modules.
  def add_included_module(module_name : String) : Nil
    @included_modules << module_name

    if Cruml::Renders::Config.verbose?
      puts "VERBOSE : #{module_name.colorize(:magenta)} module included in #{@name.colorize(:magenta)} class."
    end
  end

  # Adds a module name to the list of extended modules.
  def add_extended_module(module_name : String) : Nil
    @extended_modules << module_name

    if Cruml::Renders::Config.verbose?
      puts "VERBOSE : #{module_name.colorize(:magenta)} module extended in #{@name.colorize(:magenta)} class."
    end
  end

  # Adds a method into an array of methods.
  def add_method(method : Cruml::Entities::MethodInfo) : Nil
    if method.name == "initialize"
      @methods.unshift(method)
    else
      @methods << method
    end

    if Cruml::Renders::Config.verbose?
      puts "VERBOSE : #{method.name.colorize(:magenta)}() method to #{@name.colorize(:magenta)} class."
    end
  end
end
