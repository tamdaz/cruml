require "../spec_helper"

describe Cruml::Entities::ArgInfo do
  it "instantiates a new arg info" do
    arg_info = Cruml::Entities::ArgInfo.new("first_name", "String")
    arg_info.name.should eq("first_name")
    arg_info.type.should eq("String")
  end
end
