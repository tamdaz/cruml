require "./spec_helper"

describe Cruml do
  reflected_classes = Cruml::Reflector.reflect_classes
  reflected_link_subclasses = Cruml::Reflector.reflect_link_subclasses
  reflected_instance_vars = Cruml::Reflector.reflect_instance_vars
  reflected_methods = Cruml::Reflector.reflect_methods

  it "check config" do
    ::CRUML_FILTER_PREFIX.should eq("Example::E2")
    ::CRUML_OUT_DIR.should eq("/tmp")
  end

  it "get classes" do
    reflected_classes.empty?.should be_false
  end

  it "get inherit classes" do
    reflected_link_subclasses.should eq([
      {"Example::E2::Organization", "Example::E2::Enterprise"},
      {"Example::E2::Organization", "Example::E2::Bank"},
    ])
  end

  it "get instance vars" do
    reflected_instance_vars.should eq([
      [
        {"persons", "Int32"},
      ], [
        {"type", "String"},
      ], [
        {"clients", "Int32"},
      ],
    ])
  end

  it "get methods" do
    reflected_methods.should eq([
      [
        {:protected, "initialize", "Nil"},
        {:public, "name", "String"},
        {:public, "name=", "Nil"},
        {:public, "persons", "Int32"},
        {:public, "persons=", "Nil"},
      ], [
        {:protected, "initialize", "Nil"},
        {:public, "type", "String"},
        {:public, "type=", "Nil"},
      ], [
        {:protected, "initialize", "Nil"},
        {:public, "clients", "Int32"},
        {:public, "clients=", "Nil"},
      ],
    ])
  end
end
