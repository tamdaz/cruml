require "../spec_helper"

describe Cruml::Entities::ArgInfo do
  it "instantiates a new arg info" do
    arg_info = Cruml::Entities::ArgInfo.new("first_name", "String")
    arg_info.name.should eq("first_name")
    arg_info.type.should eq("String")
  end

  it "inserts the args into method" do
    first_name_arg = Cruml::Entities::ArgInfo.new("first_name", "String")
    last_name_arg = Cruml::Entities::ArgInfo.new("last_name", "String")

    method_info = Cruml::Entities::MethodInfo.new(:public, "full_name", "String")
    method_info.add_arg(first_name_arg)
    method_info.add_arg(last_name_arg)
    method_info.args.should eq([first_name_arg, last_name_arg])
  end
end
