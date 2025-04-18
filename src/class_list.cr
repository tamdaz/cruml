require "yaml"
require "./entities/*"

# Consists of processing a list of classes.
class Cruml::ClassList
  class_getter classes = [] of Cruml::Entities::ClassInfo

  # Adds the class info to the class array.
  def self.add(class_info : Cruml::Entities::ClassInfo) : Nil
    @@classes << class_info
  end

  # Clear the array of classes.
  def self.clear : Nil
    @@classes = [] of Cruml::Entities::ClassInfo
  end

  # Find a class info by name.
  def self.find_by_name(class_name : String) : Cruml::Entities::ClassInfo?
    @@classes.find { |class_info| class_name == class_info.name }
  end

  # Find a class info by name. Raises if not found.
  def self.find_by_name!(class_name : String) : Cruml::Entities::ClassInfo?
    @@classes.find! { |class_info| class_name == class_info.name }
  end

  # Groups the classes by their namespaces.
  def self.group_by_namespaces(test_mode : Bool = false)
    output = {} of String => Array(Cruml::Entities::ClassInfo)

    config_path = if test_mode == true
                    Dir.current + "/.cruml.test.yml"
                  else
                    Dir.current + "/.cruml.yml"
                  end

    File.open(config_path) do |file|
      namespaces = YAML.parse(file)["namespaces"]?

      if namespaces
        namespaces.as_h.each do |key, classes|
          classes_info = [] of Cruml::Entities::ClassInfo

          classes.as_a.each do |klass|
            found_class = find_by_name(klass.as_s)
            if found_class
              classes_info << found_class

              # As classes are indicated in the YML config, we can delete them in the `@@classes` class var.
              @@classes.reject! do |class_to_reject|
                class_to_reject.name == klass
              end
            end
          end

          # Namespace would be deleted if array is empty.
          unless classes_info.empty?
            output[key.as_s] = classes_info
          end
        end
      end
    end

    output
  end

  # Verifies and removes duplicated instance variables from classes based on their parent classes.
  def self.verify_instance_var_duplication : Nil
    filtered_classes = @@classes.reject(&.parent_classes.empty?).sort_by!(&.parent_classes.size)

    filtered_classes.reverse_each do |klass|
      klass.parent_classes.each do |parent_klass, _, _|
        found_class = Cruml::ClassList.find_by_name!(parent_klass)
        parent_ivars = found_class.instance_vars
        klass.instance_vars.reject! { |ivar| parent_ivars.includes?(ivar) }
      end
    end
  end
end
