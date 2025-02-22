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
  def self.find_by_name!(class_name : String) : Cruml::Entities::ClassInfo
    @@classes.find! { |class_info| class_name == class_info.name }
  end

  # Groups the classes by their namespaces.
  def self.group_by_namespaces
    @@classes.group_by(&.name.split(".").first)
  end

  def self.verify_instance_var_duplication : Nil
    self.classes.reject(&.parent_classes.empty?).sort_by!(&.parent_classes.size).reverse_each do |klass|
      klass.parent_classes.each do |parent_klass, _, _|
        parent_ivars = Cruml::ClassList.find_by_name!(parent_klass).instance_vars
        klass.instance_vars.reject! { |ivar| parent_ivars.includes?(ivar) }
      end
    end
  end
end
