require "./entities/class_info"

class Cruml::ClassList
  # An array that contains the classes to easily retrieve.
  getter classes : Array(Cruml::Entities::ClassInfo)

  def initialize : Nil
    @classes = [] of Cruml::Entities::ClassInfo
  end

  # Add a class to the collection.
  def add(class_info : Cruml::Entities::ClassInfo) : Nil
    @classes << class_info
  end
end
