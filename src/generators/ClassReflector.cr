class Cruml::ClassReflector
  # Get all specified classes.
  def self.reflect_classes : Array(String)
    reflected_class = [] of String
    {% unless Object.all_subclasses.size == 0 %}
      {% for child_class in Object.all_subclasses %}
        {% if child_class.name.starts_with?("Example") && !(child_class.name.ends_with?(".class")) %}
          reflected_class << {{ child_class.name.stringify }}
        {% end %}
      {% end %}
    {% end %}
    reflected_class
  end

  # Get all instance variables for each class.
  def self.reflect_instance_vars : Array(Array(Tuple(String, String)))
    reflected_instance_vars = [] of Array(Tuple(String, String))
    {% for child_class in Object.all_subclasses %}
      {% if child_class.name.starts_with?("Example") && !(child_class.name.ends_with?(".class")) %}
        {% unless child_class.resolve.instance_vars.empty? %}
          {% for instance_var in child_class.resolve.instance_vars %}
            {% stored_instance_var = {
                 instance_var.name.stringify, instance_var.type.stringify,
               } %}
            reflected_instance_vars << [ {{ stored_instance_var }} ]
          {% end %}
        {% end %}
      {% end %}
    {% end %}
    reflected_instance_vars
  end

  # Get all methods for each class.
  def self.reflect_methods : Array(Array(Tuple(Symbol, String, String)))
    reflected_methods = [] of Array(Tuple(Symbol, String, String))
    {% for child_class in Object.all_subclasses %}
      {% if child_class.name.starts_with?("Example") && !(child_class.name.ends_with?(".class")) %}
        {% unless child_class.methods.size == 0 %}
          # Store for each method : scope, name and return type.
          {% stored_methods = [] of Tuple(Symbol, String, String) %}
          {% for class_method in child_class.methods %}
            {% if class_method.name.stringify == "initialize" %}
              {% stored_methods.unshift({class_method.visibility, class_method.name.stringify, class_method.return_type.stringify}) %}
            {% else %}
              {% stored_methods << {class_method.visibility, class_method.name.stringify, class_method.return_type.stringify} %}
            {% end %}
          {% end %}

          reflected_methods << {{ stored_methods }}
        {% end %}
      {% end %}
    {% end %}
    reflected_methods
  end

  # List available methods for each class.
  def self.list_classes_and_methods : Nil
    reflected_classes = Cruml::ClassReflector.reflect_classes
    reflected_instance_vars = Cruml::ClassReflector.reflect_instance_vars
    reflected_methods = Cruml::ClassReflector.reflect_methods
    i = 0

    until i == reflect_classes.size
      puts "\e[4m#{reflect_classes[i]}\e[0m"
      reflected_instance_vars[i].each do |iv|
        # Scope is always set as "private" for instance vars.
        puts "\e[1m- #{iv[0]} : #{iv[1]}\e[0m"
      end
      puts "-" * 20
      reflected_methods[i].each do |m|
        puts "\e[1m#{get_scope(m[-3])} #{m[-2]} : #{m[-1].empty? ? "Nil" : m[-1]}\e[0m"
      end
      puts "\n"
      i += 1
    end
  end

  # Return the scope with special character.
  # - "+" is "public"
  # - "#" is "protected"
  # - "-" is "private"
  private def self.get_scope(litteral_scope : Symbol) : String
    case litteral_scope
    when :public    then "+"
    when :protected then "#"
    when :private   then "-"
    else                 "+"
    end
  end
end
