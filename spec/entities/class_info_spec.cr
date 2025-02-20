require "spec"

describe Cruml::Entities::ClassInfo do
  describe "#initialize" do
    it "initializes with name and type" do
      class_info = Cruml::Entities::ClassInfo.new("Person", :class)
      class_info.name.should eq("Person")
      class_info.type.should eq(:class)
      class_info.instance_vars.should be_empty
      class_info.parent_classes.should be_empty
      class_info.methods.should be_empty
    end
  end

  describe "#add_instance_var" do
    it "adds an instance variable" do
      class_info = Cruml::Entities::ClassInfo.new("Person", :class)
      class_info.add_instance_var("first_name", "String")
      class_info.instance_vars.should eq([{"first_name", "String"}])
    end

    it "replaces an existing instance variable with the same name" do
      class_info = Cruml::Entities::ClassInfo.new("Person", :class)
      class_info.add_instance_var("first_name", "String")
      class_info.add_instance_var("first_name", "Int32") # replace the ivar with different type.
      class_info.instance_vars.should eq([{"first_name", "Int32"}])
    end
  end

  describe "#add_parent_class" do
    it "adds a parent class" do
      class_info = Cruml::Entities::ClassInfo.new("Employee", :class)
      class_info.add_parent_class("Person")
      class_info.parent_classes.should eq([{"Person", "Employee", :class}])
    end
  end

  describe "#add_method" do
    it "adds a method" do
      class_info = Cruml::Entities::ClassInfo.new("Person", :class)
      method_info = Cruml::Entities::MethodInfo.new(:public, "major?", "Bool")

      class_info.add_method(method_info)
      class_info.methods.should eq([method_info])
    end

    it "adds the initialize method at the beginning" do
      class_info = Cruml::Entities::ClassInfo.new("Person", :class)
      initialize_method = Cruml::Entities::MethodInfo.new(:public, "initialize", "Nil")
      is_major_method = Cruml::Entities::MethodInfo.new(:public, "major?", "Bool")
      class_info.add_method(is_major_method)
      class_info.add_method(initialize_method)
      class_info.methods.should eq([initialize_method, is_major_method])
    end
  end
end
