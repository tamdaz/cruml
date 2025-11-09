module E16::Timestampable
  property created_at : Time?
  property updated_at : Time?

  def touch : Void
    @updated_at = Time.utc
  end
end

module E16::Loggable
  def log(message : String) : Void
    puts "[#{Time.utc}] #{message}"
  end
end

module E16::Serializable
  abstract def to_json : String
  abstract def from_json(json : String) : Void
end

class E16::BaseModel
  include E16::Timestampable
  include E16::Loggable

  property id : Int64

  def initialize(@id : Int64)
    @created_at = Time.utc
  end
end

class E16::User < E16::BaseModel
  include E16::Serializable

  property name : String
  property email : String

  def initialize(@id : Int64, @name : String, @email : String)
    super(@id)
  end

  def to_json : String
    %({{"id": #{@id}, "name": "#{@name}", "email": "#{@email}"}})
  end

  def from_json(json : String) : Void; end
end

class E16::Article < E16::BaseModel
  property title : String
  property content : String
  property author : E16::User

  def initialize(@id : Int64, @title : String, @content : String, @author : User)
    super(@id)
  end

  def publish : Void
    log("Publishing article: #{@title}")
    touch
  end
end
