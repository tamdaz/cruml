require "./spec_helper"

describe Cruml do
  it "has been reflected" do
    get_reflection.should_not be_nil
  end

  it "gets any classes type" do
    get_reflection.classes.size.should eq(10)
  end

  it "gets the normal classes" do
    class_list = get_reflection.classes.select do |class_info|
      class_info.type == :class
    end

    class_list.size.should eq(7)
  end

  it "gets the interfaces" do
    interfaces = get_reflection.classes.select do |class_info|
      class_info.type == :interface
    end

    interfaces.size.should eq(2)
  end

  it "gets the abstract class" do
    abstract_classes = get_reflection.classes.select do |class_info|
      class_info.type == :abstract
    end

    abstract_classes.size.should eq(1)
  end
end
