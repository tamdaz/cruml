# Test extend modules (class methods)
module E21::ClassMethods
  def create(name : String) : self
    new(name)
  end

  def all : Array(self)
    [] of self
  end
end

module E21::Comparable
  def compare(other : self) : Int32
    0
  end
end

class E21::Product
  extend E21::ClassMethods
  include E21::Comparable

  property name : String

  def initialize(@name : String); end

  def to_s : String
    @name
  end
end

class E21::Book < E21::Product
  property author : String

  def initialize(name : String, @author : String)
    super(name)
  end
end
