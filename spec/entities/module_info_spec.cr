require "spec"

describe Cruml::Entities::ModuleInfo do
  it "initializes with a name" do
    module_info = Cruml::Entities::ModuleInfo.new("TestModule")
    module_info.name.should eq("TestModule")
  end

  it "initializes with empty methods and instance_vars" do
    module_info = Cruml::Entities::ModuleInfo.new("TestModule")
    module_info.methods.should be_empty
    module_info.instance_vars.should be_empty
  end

  it "adds a method to the methods array" do
    module_info = Cruml::Entities::ModuleInfo.new("TestModule")
    method_info = Cruml::Entities::MethodInfo.new(:public, "greet", "String")
    module_info.add_method(method_info)
    module_info.methods.should eq([method_info])
  end

  it "adds an instance variable to the instance_vars array" do
    module_info = Cruml::Entities::ModuleInfo.new("TestModule")
    module_info.add_instance_var("var_name", "String")
  end

  it "replaces an existing instance variable with the same name" do
    module_info = Cruml::Entities::ModuleInfo.new("TestModule")
    module_info.add_instance_var("var_name", "String")
    module_info.add_instance_var("var_name", "Int32")
    module_info.instance_vars.should eq([{"var_name", "Int32"}])
    module_info.instance_vars.should_not eq([{"var_name", "String"}])
  end
end
