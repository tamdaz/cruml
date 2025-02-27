# This consists of obtaining information about the class.
class Cruml::Entities::ClassInfo
  getter name : String
  getter type : Symbol
  getter parent_classes = [] of Tuple(String, String, Symbol)
  getter included_modules = [] of String
  getter instance_vars = [] of Tuple(String, String)
  getter methods = [] of Cruml::Entities::MethodInfo

  def initialize(@name : String, @type : Symbol); end

  # Adds the name and the type of a instance variable into the instance vars array.
  def add_instance_var(name : String, type : String) : Nil
    @instance_vars.reject! { |ivar| ivar[0] == name }
    @instance_vars << {name, type}

    if Cruml::Renders::Config.verbose? == true
      puts "VERBOSE : #{@name.colorize(:magenta)} instance var added to #{@name.colorize(:magenta)} class."
    end
  end

  # Adds a parent class into an array of parent classes.
  def add_parent_class(parent_class_name : String) : Nil
    found_class = Cruml::ClassList.find_by_name(parent_class_name)
    if found_class
      @parent_classes << {parent_class_name, @name, found_class.type}
    end

    if Cruml::Renders::Config.verbose? == true
      puts "VERBOSE : #{@name.colorize(:magenta)} child class linked to #{parent_class_name.colorize(:magenta)} parent class."
    end
  end

  # Adds a module name to the list of included modules.
  def add_included_module(module_name : String) : Nil
    @included_modules << module_name

    if Cruml::Renders::Config.verbose? == true
      puts "VERBOSE : #{module_name.colorize(:magenta)} module to #{@name.colorize(:magenta)} class."
    end
  end

  # Adds a method into an array of methods.
  def add_method(method : Cruml::Entities::MethodInfo) : Nil
    if method.name == "initialize"
      @methods.unshift(method)
    else
      @methods << method
    end

    if Cruml::Renders::Config.verbose? == true
      puts "VERBOSE : #{method.name.colorize(:magenta)}() method to #{@name.colorize(:magenta)} class."
    end
  end
end
