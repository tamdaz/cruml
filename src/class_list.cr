require "./entities/*"

# Consists of processing a list of classes.
class Cruml::ClassList
  class_getter classes = [] of Cruml::Entities::ClassInfo

  # Adds the class info to the class array.
  def self.add(class_info : Cruml::Entities::ClassInfo) : Nil
    @@classes << class_info
  end

  # Find a class info by name.
  def self.find_by_name(class_name : String) : Cruml::Entities::ClassInfo
    @@classes.find! { |class_info| class_name == class_info.name }
  end
end
