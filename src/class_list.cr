# Consists of processing a list of classes.
class Cruml::ClassList
  # An array that contains the classes to easily retrieve.
  getter classes : Array(Cruml::Entities::ClassInfo)

  # When instantiating the `Cruml::ClassList` class. A list of reflected classes are empty by default.
  def initialize : Nil
    @classes = [] of Cruml::Entities::ClassInfo
  end

  # Adds a reflected class into class list.
  def add(class_info : Cruml::Entities::ClassInfo) : Nil
    @classes << class_info
  end
end
