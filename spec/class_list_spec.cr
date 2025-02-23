require "./spec_helper"
require "./../src/class_list"
require "./../src/entities/class_info"

describe Cruml::ClassList do
  describe "#find_by_name" do
    it "adds and finds a class by name" do
      class_info = Cruml::Entities::ClassInfo.new("TestClass", :class)
      Cruml::ClassList.add(class_info)

      found_class = Cruml::ClassList.find_by_name("TestClass")
      found_class.should eq(class_info)
    end

    it "raises an error when class is not found" do
      expect_raises(Enumerable::NotFoundError) do
        Cruml::ModuleList.find_by_name("NonExistentClass")
      end
    end
  end

  describe "#group_by_namespaces" do
    it "groups classes by namespaces (depth level at 1)" do
      class_info1 = Cruml::Entities::ClassInfo.new("Namespace1::Class1", :class)
      Cruml::ClassList.add(class_info1)

      class_info2 = Cruml::Entities::ClassInfo.new("Namespace1::Class2", :class)
      Cruml::ClassList.add(class_info2)

      class_info3 = Cruml::Entities::ClassInfo.new("Namespace2::Class1", :class)
      Cruml::ClassList.add(class_info3)

      grouped_classes = Cruml::ClassList.group_by_namespaces
      grouped_classes["Namespace1"].should eq([class_info1, class_info2])
      grouped_classes["Namespace2"].should eq([class_info3])
    end

    it "groups classes by namespaces (depth level at n)" do
      class_info1 = Cruml::Entities::ClassInfo.new("N1::SN1::Class1", :class)
      Cruml::ClassList.add(class_info1)

      class_info2 = Cruml::Entities::ClassInfo.new("N1::SN2::Class2", :class)
      Cruml::ClassList.add(class_info2)

      class_info3 = Cruml::Entities::ClassInfo.new("N2::Class1", :class)
      Cruml::ClassList.add(class_info3)

      grouped_classes = Cruml::ClassList.group_by_namespaces
      grouped_classes["N1::SN1"].should eq([class_info1])
      grouped_classes["N1::SN2"].should eq([class_info2])
      grouped_classes["N2"].should eq([class_info3])
    end
  end

  describe "#verify_instance_var_duplication" do
    it "verifies instance variable duplication" do
      class_info1 = Cruml::Entities::ClassInfo.new("TestClass", :class)
      class_info1.add_instance_var("@var1", "String")
      Cruml::ClassList.add(class_info1)

      class_info2 = Cruml::Entities::ClassInfo.new("TestSubClass", :class)
      class_info2.add_instance_var("@var1", "String")
      class_info2.add_parent_class("TestClass")
      Cruml::ClassList.add(class_info2)

      Cruml::ClassList.verify_instance_var_duplication

      class_info1.instance_vars.should eq([
        {"@var1", "String"},
      ])

      class_info2.instance_vars.should eq(
        [] of Cruml::Entities::ClassInfo
      )
    end

    it "detects no instance variable duplication" do
      class_info1 = Cruml::Entities::ClassInfo.new("TestClass", :class)
      class_info1.add_instance_var("@var1", "String")
      Cruml::ClassList.add(class_info1)

      class_info2 = Cruml::Entities::ClassInfo.new("TestClass", :class)
      class_info2.add_instance_var("@var2", "Int32")
      Cruml::ClassList.add(class_info2)

      Cruml::ClassList.verify_instance_var_duplication

      class_info1.instance_vars.should eq([
        {"@var1", "String"},
      ])

      class_info2.instance_vars.should eq([
        {"@var2", "Int32"},
      ])
    end
  end

  after_each { Cruml::ClassList.clear }
end
