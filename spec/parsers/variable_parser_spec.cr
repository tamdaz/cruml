require "../spec_helper"
require "../../src/parsers/variable_parser"

describe Cruml::Parsers::VariableParser do
  it "parses property attribute" do
    result = Cruml::Parsers::VariableParser.parse_instance_attribute("property(name : String)")

    result.should_not be_nil
    result.try do |real_result|
      real_result[:visibility].should eq("property")
      real_result[:name].should eq("name")
      real_result[:type].should eq("String")
    end
  end

  it "parses getter attribute" do
    result = Cruml::Parsers::VariableParser.parse_instance_attribute("getter(age : Int32)")

    result.should_not be_nil
    result.try do |real_result|
      real_result[:visibility].should eq("getter")
      real_result[:name].should eq("age")
      real_result[:type].should eq("Int32")
    end
  end

  it "returns nil for invalid format" do
    result = Cruml::Parsers::VariableParser.parse_instance_attribute("invalid")
    result.should be_nil
  end

  it "parses class_property attribute" do
    result = Cruml::Parsers::VariableParser.parse_class_attribute("class_property(config : Config)")

    result.should_not be_nil
    result.try do |real_result|
      real_result[:visibility].should eq("class_property")
      real_result[:name].should eq("config")
      real_result[:type].should eq("Config")
    end
  end

  it "parses class_getter attribute" do
    result = Cruml::Parsers::VariableParser.parse_class_attribute("class_getter(instance : Instance)")

    result.should_not be_nil
    result.try do |real_result|
      real_result[:visibility].should eq("class_getter")
      real_result[:name].should eq("instance")
      real_result[:type].should eq("Instance")
    end
  end

  it "parses instance variable declaration" do
    result = Cruml::Parsers::VariableParser.parse_instance_var_declaration("@name : String")

    result.should_not be_nil
    result.try do |real_result|
      real_result[:name].should eq("name")
      real_result[:type].should eq("String")
    end
  end

  it "parses complex type declarations" do
    result = Cruml::Parsers::VariableParser.parse_instance_var_declaration("@items : Array(String)")

    result.should_not be_nil
    result.try do |real_result|
      real_result[:name].should eq("items")
      real_result[:type].should eq("Array(String)")
    end
  end

  it "parses instance variable assignment" do
    result = Cruml::Parsers::VariableParser.parse_instance_var_assignment("@name = name", "name")

    result.should eq("name")
  end

  it "returns nil when argument doesn't match" do
    result = Cruml::Parsers::VariableParser.parse_instance_var_assignment("@name = other", "name")

    result.should be_nil
  end

  it "returns true when names match" do
    result = Cruml::Parsers::VariableParser.matches_instance_var?("@name", "name")
    result.should be_true
  end

  it "returns false when names don't match" do
    result = Cruml::Parsers::VariableParser.matches_instance_var?("@email", "name")
    result.should be_false
  end
end
