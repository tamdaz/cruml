class E15::Repository(T)
  property items : Array(T)

  def initialize
    @items = [] of T
  end

  def add(item : T) : Void
    @items << item
  end

  def find_by_id(id : Int32) : T?
    @items[id]?
  end

  def all : Array(T)
    @items
  end
end

class E15::CachedRepository(T) < E15::Repository(T)
  property cache : Hash(String, T)

  def initialize
    super
    @cache = {} of String => T
  end

  def add_to_cache(key : String, item : T) : Void
    @cache[key] = item
  end

  def get_from_cache(key : String) : T?
    @cache[key]?
  end
end

class E15::Pair(K, V)
  property key : K
  property value : V

  def initialize(@key : K, @value : V); end

  def swap : E15::Pair(V, K)
    E15::Pair(V, K).new(@value, @key)
  end
end

class E15::Triple(A, B, C)
  property first : A
  property second : B
  property third : C

  def initialize(@first : A, @second : B, @third : C); end
end
