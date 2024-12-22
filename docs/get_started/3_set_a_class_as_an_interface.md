```crystal
@[Cruml::Annotation::AsInterface]
abstract class Person
  abstract def full_name : String
end

class Employee < Person
  getter first_name : String
  getter last_name : String

  def initialize(@first_name : String, @last_name : String); end

  def full_name : String
    "#{@first_name} #{@last_name}"
  end
end
```