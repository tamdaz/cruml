class E22::Person
  @first_name : String
  @last_name : String

  @@tall : Float32

  def initialize(first_name : String, last_name : String)
    @first_name = first_name
    @last_name = last_name
  end
end
