class Cruml::ClassReflector
  # Get all specified classes.
  def self.reflect_classes : Array(String)
    reflected_class = [] of String
    {% for child_class in Object.all_subclasses %}
      {% if child_class.name.starts_with?("Example") && !(child_class.name.ends_with?(".class")) %}
        reflected_class << "{{ child_class.name }}"
      {% end %}
    {% end %}
    reflected_class
  end

  # Get all methods for each class.
  def self.reflect_methods
    reflected_methods = [] of Array(Tuple(Symbol, String, String))
    {% for child_class in Object.all_subclasses %}
      {% if child_class.name.starts_with?("Example") && !(child_class.name.ends_with?(".class")) %}
        # Store for each method : scope, name and return type.
        {% stored_methods = [] of Tuple(Symbol, String, String) %}
        {% for class_method in child_class.methods %}
          {% stored_methods << { class_method.visibility, "#{class_method.name}", "#{class_method.return_type}" } %}
        {% end %}
        reflected_methods << {{ stored_methods }}
      {% end %}
    {% end %}
    reflected_methods
  end

  # List available methods for each class.
  def self.list_classes_and_methods : Nil
    reflected_classes = Cruml::ClassReflector.reflect_classes
    reflected_methods = Cruml::ClassReflector.reflect_methods
    i = 0

    until i == reflect_classes.size
      puts reflect_classes[i]
      reflected_methods[i].each do |m|
        puts "- #{m[-3]} #{m[-2]} : #{m[-1].empty? ? "Nil" : m[-1]}"
      end
      i += 1
    end
  end
end
