require "./entities/*"

# Consists of processing a list of modules.
class Cruml::ModuleList
  class_getter modules = [] of Cruml::Entities::ModuleInfo

  # Adds the module info to the module array.
  def self.add(module_info : Cruml::Entities::ModuleInfo) : Nil
    @@modules << module_info
  end

  # Clear the array of modules.
  def self.clear : Nil
    @@modules = [] of Cruml::Entities::ModuleInfo
  end

  # Find a module info by name.
  def self.find_by_name!(module_name : String) : Cruml::Entities::ModuleInfo
    @@modules.find! { |module_info| module_name == module_info.name }
  end
end
