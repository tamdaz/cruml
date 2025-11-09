class E19::Model
  getter id : Int64
  setter name : String
  property email : String
  property? active : Bool

  property tags : Array(String)
  property scores : Array(Int32)

  property metadata : Hash(String, String)
  property settings : Hash(Symbol, Bool)

  property description : String?
  property created_at : Time?

  property value : String | Int32 | Float64

  property config : Hash(String, Array(Int32))

  def initialize(@id : Int64, @name : String, @email : String, @active : Bool = true)
    @tags = [] of String
    @scores = [] of Int32
    @metadata = {} of String => String
    @settings = {} of Symbol => Bool
    @value = ""
    @config = {} of String => Array(Int32)
  end

  def add_tag(tag : String) : Void
    @tags << tag
  end

  def add_metadata(key : String, value : String) : Void
    @metadata[key] = value
  end

  private def validate : Bool
    !@name.empty? && !@email.empty?
  end

  protected def internal_process : Void
    validate
  end
end

class E19::ExtendedModel < E19::Model
  property extra_data : Hash(String, String | Int32 | Bool)
  property related_ids : Array(Int64)

  def initialize(@id : Int64, @name : String, @email : String, @active : Bool = true)
    super(@id, @name, @email, @active)

    @extra_data = {} of String => String | Int32 | Bool
    @related_ids = [] of Int64
  end
end
