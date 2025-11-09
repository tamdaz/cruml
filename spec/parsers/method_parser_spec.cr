require "../spec_helper"
require "compiler/crystal/syntax"
require "../../src/parsers/method_parser"
require "../../src/entities/method_info"

describe Cruml::Parsers::MethodParser do
  it "returns :protected for initialize method" do
    visibility = Cruml::Parsers::MethodParser.determine_visibility("initialize")
    visibility.should eq(:protected)
  end

  it "returns :public for regular methods" do
    visibility = Cruml::Parsers::MethodParser.determine_visibility("my_method")
    visibility.should eq(:public)
  end

  it "converts Protected modifier to :protected" do
    visibility = Cruml::Parsers::MethodParser.visibility_from_modifier(Crystal::Visibility::Protected)
    visibility.should eq(:protected)
  end

  it "converts Private modifier to :private" do
    visibility = Cruml::Parsers::MethodParser.visibility_from_modifier(Crystal::Visibility::Private)
    visibility.should eq(:private)
  end

  it "converts Public modifier to :public" do
    visibility = Cruml::Parsers::MethodParser.visibility_from_modifier(Crystal::Visibility::Public)
    visibility.should eq(:public)
  end

  it "returns the return type when specified" do
    code = "def my_method : String; end"
    ast = Crystal::Parser.parse(code)
    node = ast.as(Crystal::Def)

    return_type = Cruml::Parsers::MethodParser.get_return_type(node)
    return_type.should eq("String")
  end

  it "returns Nil when return type is not specified" do
    code = "def my_method; end"
    ast = Crystal::Parser.parse(code)
    node = ast.as(Crystal::Def)

    return_type = Cruml::Parsers::MethodParser.get_return_type(node)
    return_type.should eq("Nil")
  end
end
