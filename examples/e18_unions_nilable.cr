class E18::Response
  property status : Int32
  property body : String | Hash(String, String) | Nil

  def initialize(@status : Int32, @body : String | Hash(String, String) | Nil = nil); end

  def success? : Bool
    @status >= 200 && @status < 300
  end
end

class E18::Result(T)
  property value : T
  property error : String | Nil

  def initialize(@value : T = nil, @error : String | Nil = nil); end

  def success? : Bool
    !@value.nil? && @error.nil?
  end

  def failure? : Bool
    !success?
  end

  def unwrap : T
    @value
  end
end

class E18::Container
  property data : String | Int32 | Float64 | Bool | Nil

  def initialize(@data : String | Int32 | Float64 | Bool | Nil = nil); end

  def type_name : String
    case @data
    when String  then "string"
    when Int32   then "integer"
    when Float64 then "float"
    when Bool    then "boolean"
    else              "nil"
    end
  end
end

class E18::Optional(T)
  property value : T?

  def initialize(@value : T? = nil); end

  def present? : Bool
    !@value.nil?
  end

  def or_else(default : T) : T
    @value || default
  end
end
