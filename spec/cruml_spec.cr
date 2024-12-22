require "./spec_helper"

describe Cruml do
  it "has been reflected" do
    get_reflection.should_not be_nil
  end

  it "get any type of classes" do
    get_reflection.classes.size.should eq(10)
  end

  it "get normal classes" do
    class_list = get_reflection.classes.select do |class_info|
      class_info.type == :class
    end

    class_list.size.should eq(7)
  end

  it "get interfaces" do
    interfaces = get_reflection.classes.select do |class_info|
      class_info.type == :interface
    end

    interfaces.size.should eq(2)
  end

  it "get abstract class" do
    abstract_classes = get_reflection.classes.select do |class_info|
      class_info.type == :abstract
    end

    abstract_classes.size.should eq(1)
  end
end
