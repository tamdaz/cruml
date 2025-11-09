require "yaml"
require "../entities/class_info"
require "../entities/module_info"

# Service to manage the collection of classes and modules
# This replaces the global class_getter pattern with a proper service
class Cruml::Services::RegistryService
  # Array of classes
  getter classes = [] of Cruml::Entities::ClassInfo

  # Array of modules
  getter modules = [] of Cruml::Entities::ModuleInfo

  def add_class(class_info : Cruml::Entities::ClassInfo) : Nil
    @classes << class_info
  end

  def find_class(class_name : String) : Cruml::Entities::ClassInfo?
    @classes.find { |class_info| class_name == class_info.name }
  end

  def find_class!(class_name : String) : Cruml::Entities::ClassInfo
    @classes.find! { |class_info| class_name == class_info.name }
  end

  def add_module(module_info : Cruml::Entities::ModuleInfo) : Nil
    @modules << module_info
  end

  def find_module(module_name : String) : Cruml::Entities::ModuleInfo?
    @modules.find { |module_info| module_name == module_info.name }
  end

  def find_module!(module_name : String) : Cruml::Entities::ModuleInfo
    @modules.find! { |module_info| module_name == module_info.name }
  end

  def clear : Nil
    @classes.clear
    @modules.clear
  end

  # Groups classes by their namespaces defined in the YML config
  def group_classes_by_namespaces(test_mode : Bool = false) : Hash(String, Array(Cruml::Entities::ClassInfo))
    output = {} of String => Array(Cruml::Entities::ClassInfo)

    config_path = if test_mode
                    Dir.current + "/.cruml.test.yml"
                  else
                    Dir.current + "/.cruml.yml"
                  end

    unless File.exists?(config_path)
      return output
    end

    File.open(config_path) do |file|
      if namespaces = YAML.parse(file)["namespaces"]?
        namespaces.as_h.each do |key, classes|
          classes_info = [] of Cruml::Entities::ClassInfo

          classes.as_a.each do |klass|
            if found_class = find_class(klass.as_s)
              classes_info << found_class

              # Remove classes that are in the YML config from the main array
              @classes.reject! { |kls| kls.name == klass.as_s }
            end
          end

          # Only add namespace if it has classes
          output[key.as_s] = classes_info unless classes_info.empty?
        end
      end
    end

    output
  end

  # Groups modules by their namespaces (infers from module names)
  def group_modules_by_namespaces : Hash(String, Array(Cruml::Entities::ModuleInfo))
    output = {} of String => Array(Cruml::Entities::ModuleInfo)

    @modules.each do |the_module|
      if the_module.name.includes?("::")
        parts = the_module.name.split("::")
        # Use all parts except the last one as namespace
        namespace = parts[0..-2].join("::")

        unless namespace.empty?
          output[namespace] ||= [] of Cruml::Entities::ModuleInfo
          output[namespace] << the_module
        end
      end
    end

    # Remove grouped modules from the main array
    output.each_value do |modules|
      modules.each do |the_module|
        @modules.reject! { |mod| mod.name == the_module.name }
      end
    end

    output
  end

  # Removes duplicated instance variables from child classes
  # that are already defined in parent classes
  def remove_duplicate_instance_vars : Nil
    # Get classes with parents, sorted by inheritance depth
    classes_with_parents = @classes.select { |klass| !klass.parent_classes.empty? }
      .sort_by!(&.parent_classes.size)

    classes_with_parents.reverse_each do |klass|
      klass.parent_classes.each do |parent_name, _, _|
        # Use find_class instead of find_class! to handle cases where parent might not be found
        if parent = find_class(parent_name)
          parent_ivars = parent.instance_vars

          # Remove instance variables that exist in parent
          klass.instance_vars.reject! { |ivar| parent_ivars.includes?(ivar) }
        end
      end
    end
  end
end
