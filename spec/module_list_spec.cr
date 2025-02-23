require "../src/module_list"
require "spec"

describe Cruml::ModuleList do
  describe "#add" do
    it "adds a module to the list" do
      module_info = Cruml::Entities::ModuleInfo.new("TestModule")
      Cruml::ModuleList.add(module_info)
      Cruml::ModuleList.modules.should eq([module_info])
    end
  end

  describe "#find_by_name" do
    it "finds a module by name" do
      module_info = Cruml::Entities::ModuleInfo.new("TestModule")
      Cruml::ModuleList.add(module_info)
      found_module = Cruml::ModuleList.find_by_name("TestModule")
      found_module.should eq(module_info)
    end

    it "raises an error when module is not found" do
      expect_raises(Enumerable::NotFoundError) do
        Cruml::ModuleList.find_by_name("NonExistentModule")
      end
    end
  end

  after_each { Cruml::ModuleList.clear }
end
