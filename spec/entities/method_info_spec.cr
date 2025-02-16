require "../spec_helper"

describe Cruml::Entities::MethodInfo do
  it "instantiates a method info" do
    method_info = Cruml::Entities::MethodInfo.new(:public, "full_name", "String")
    method_info.scope.should eq(:public)
    method_info.name.should eq("full_name")
    method_info.return_type.should eq("String")
  end

  it "instantiates a method info with arguments" do
    method_info = Cruml::Entities::MethodInfo.new(:public, "full_name", "String")
    method_info.add_arg(Cruml::Entities::ArgInfo.new("first_name", "String"))
    method_info.add_arg(Cruml::Entities::ArgInfo.new("last_name", "String"))
    method_info.scope.should eq(:public)
    method_info.name.should eq("full_name")
    method_info.return_type.should eq("String")
    method_info.generate_args.should eq("first_name : String, last_name : String")
  end
end
