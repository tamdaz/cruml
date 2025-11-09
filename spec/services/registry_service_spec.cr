require "../spec_helper"
require "../../src/services/registry_service"
require "../../src/entities/class_info"
require "../../src/entities/module_info"

describe Cruml::Services::RegistryService do
  it "adds and finds a class by name" do
    registry = Cruml::Services::RegistryService.new
    class_info = Cruml::Entities::ClassInfo.new("TestClass", :class)

    registry.add_class(class_info)
    found_class = registry.find_class!("TestClass")

    found_class.should eq(class_info)
  end

  it "returns nil when class is not found" do
    registry = Cruml::Services::RegistryService.new

    found_class = registry.find_class("NonExistent")
    found_class.should be_nil
  end

  it "raises when find_class! doesn't find a class" do
    registry = Cruml::Services::RegistryService.new

    expect_raises(Enumerable::NotFoundError) do
      registry.find_class!("NonExistent")
    end
  end

  it "adds and finds a module by name" do
    registry = Cruml::Services::RegistryService.new
    module_info = Cruml::Entities::ModuleInfo.new("TestModule", :normal)

    registry.add_module(module_info)
    found_module = registry.find_module!("TestModule")

    found_module.should eq(module_info)
  end

  it "returns nil when module is not found" do
    registry = Cruml::Services::RegistryService.new

    found_module = registry.find_module("NonExistent")
    found_module.should be_nil
  end

  it "clears all classes and modules" do
    registry = Cruml::Services::RegistryService.new

    registry.add_class(Cruml::Entities::ClassInfo.new("Class1", :class))
    registry.add_module(Cruml::Entities::ModuleInfo.new("Module1", :normal))

    registry.clear

    registry.classes.should be_empty
    registry.modules.should be_empty
  end

  it "removes duplicated instance variables from child classes" do
    registry = Cruml::Services::RegistryService.new

    # Create parent class
    parent = Cruml::Entities::ClassInfo.new("Parent", :class)
    parent.add_instance_var("@name", "String")
    parent.add_instance_var("@age", "Int32")
    registry.add_class(parent)

    # Create child class with duplicated vars
    child = Cruml::Entities::ClassInfo.new("Child", :class)
    # Manually add parent relationship without using add_parent_class
    child.parent_classes << {"Parent", "Child", :class}
    child.add_instance_var("@name", "String")
    child.add_instance_var("@age", "Int32")
    child.add_instance_var("@email", "String")
    registry.add_class(child)

    registry.remove_duplicate_instance_vars

    # Parent should keep all vars
    parent.instance_vars.size.should eq(2)

    # Child should only have unique vars
    child.instance_vars.size.should eq(1)
    child.instance_vars[0][0].should eq("@email")
  end

  it "handles multiple levels of inheritance" do
    registry = Cruml::Services::RegistryService.new

    # GrandParent
    grandparent = Cruml::Entities::ClassInfo.new("GrandParent", :class)
    grandparent.add_instance_var("@id", "Int64")
    registry.add_class(grandparent)

    # Parent
    parent = Cruml::Entities::ClassInfo.new("Parent", :class)
    parent.parent_classes << {"GrandParent", "Parent", :class}
    parent.add_instance_var("@id", "Int64")
    parent.add_instance_var("@name", "String")
    registry.add_class(parent)

    # Child
    child = Cruml::Entities::ClassInfo.new("Child", :class)
    child.parent_classes << {"Parent", "Child", :class}
    child.add_instance_var("@id", "Int64")
    child.add_instance_var("@name", "String")
    child.add_instance_var("@email", "String")
    registry.add_class(child)

    registry.remove_duplicate_instance_vars

    # GrandParent should keep all vars
    grandparent.instance_vars.size.should eq(1)

    # Parent should only have name (id is from grandparent)
    parent.instance_vars.size.should eq(1)
    parent.instance_vars[0][0].should eq("@name")

    # Child should only have email
    child.instance_vars.size.should eq(1)
    child.instance_vars[0][0].should eq("@email")
  end
end
