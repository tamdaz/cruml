require "../spec_helper"
require "compiler/crystal/syntax"
require "../../src/parsers/class_parser"

describe Cruml::Parsers::ClassParser do
  it "identifies interface by name" do
    code = "class MyInterface; end"
    ast = Crystal::Parser.parse(code)
    node = ast.as(Crystal::ClassDef)

    class_type = Cruml::Parsers::ClassParser.determine_class_type("MyInterface", node)
    class_type.should eq(:interface)
  end

  it "identifies abstract class" do
    code = "abstract class MyClass; end"
    ast = Crystal::Parser.parse(code)
    node = ast.as(Crystal::ClassDef)

    class_type = Cruml::Parsers::ClassParser.determine_class_type("MyClass", node)
    class_type.should eq(:abstract)
  end

  it "identifies normal class" do
    code = "class MyClass; end"
    ast = Crystal::Parser.parse(code)
    node = ast.as(Crystal::ClassDef)

    class_type = Cruml::Parsers::ClassParser.determine_class_type("MyClass", node)
    class_type.should eq(:class)
  end

  it "extracts generic type parameters" do
    code = "class Container(T); end"
    ast = Crystal::Parser.parse(code)
    node = ast.as(Crystal::ClassDef)

    generics = Cruml::Parsers::ClassParser.extract_generics(node)
    generics.should eq("(T)")
  end

  it "extracts multiple generic parameters" do
    code = "class Pair(K, V); end"
    ast = Crystal::Parser.parse(code)
    node = ast.as(Crystal::ClassDef)

    generics = Cruml::Parsers::ClassParser.extract_generics(node)
    generics.should eq("(K, V)")
  end

  it "returns nil for non-generic class" do
    code = "class MyClass; end"
    ast = Crystal::Parser.parse(code)
    node = ast.as(Crystal::ClassDef)

    generics = Cruml::Parsers::ClassParser.extract_generics(node)
    generics.should be_nil
  end

  it "parses single include statement" do
    body = "include MyModule"

    includes = Cruml::Parsers::ClassParser.parse_includes(body)
    includes.should eq(["MyModule"])
  end

  it "parses multiple include statements" do
    body = <<-BODY
      include ModuleA
      include ModuleB
      include ModuleC
      BODY

    includes = Cruml::Parsers::ClassParser.parse_includes(body)
    includes.should eq(["ModuleA", "ModuleB", "ModuleC"])
  end

  it "parses namespaced includes" do
    body = "include MyNamespace::MyModule"

    includes = Cruml::Parsers::ClassParser.parse_includes(body)
    includes.should eq(["MyNamespace::MyModule"])
  end

  it "returns empty array when no includes" do
    body = "property name : String"

    includes = Cruml::Parsers::ClassParser.parse_includes(body)
    includes.should be_empty
  end

  it "returns true for interface names" do
    result = Cruml::Parsers::ClassParser.interface?("MyInterface")
    result.should be_true
  end

  it "returns true for interface names in any case" do
    result = Cruml::Parsers::ClassParser.interface?("Myinterface")
    result.should be_true
  end

  it "returns false for non-interface names" do
    result = Cruml::Parsers::ClassParser.interface?("MyClass")
    result.should be_false
  end
end
