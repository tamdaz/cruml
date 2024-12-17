# ```text
# - Array of classes
#  - Classes (name only)
#   - Instance vars (name and type)
#   - Methods (scope, name and return type)
# ```
class Cruml::Reflector
  # Get all specified classes.
  def self.reflect_classes : ClassArray
    reflected_class = [] of String
    {% unless Object.all_subclasses.size == 0 %}
      {% for subclass in Object.all_subclasses %}
        {% if subclass.name.starts_with?(::CRUML_FILTER_PREFIX) && !(subclass.name.ends_with?(".class")) %}
          {% unless subclass.name.ends_with?(":Module") %}
            reflected_class << {{ subclass.name.stringify }}
          {% end %}
        {% end %}
      {% end %}
    {% end %}
    reflected_class
  end

  # Get all links between the parent and the child class.
  def self.reflect_link_subclasses : LinkSubClassArray
    reflected_link_subclasses = [] of Tuple(String, String)
    {% unless Object.all_subclasses.size == 0 %}
      {% for subclass in Object.all_subclasses %}
        {% if subclass.name.starts_with?(::CRUML_FILTER_PREFIX) && !(subclass.name.ends_with?(".class")) %}
          {% unless subclass.name.ends_with?(":Module") || subclass.subclasses.empty? %}
            {% for child_class in subclass.subclasses %}
              reflected_link_subclasses << {{ {subclass.name.stringify, child_class.stringify} }}
            {% end %}
          {% end %}
        {% end %}
      {% end %}
    {% end %}
    reflected_link_subclasses
  end

  # Get all instance variables for each class.
  def self.reflect_instance_vars : Array(InstanceVarsArray)
    reflected_instance_vars = [] of InstanceVarsArray
    {% for subclass in Object.all_subclasses %}
      {% if subclass.name.starts_with?(::CRUML_FILTER_PREFIX) && !(subclass.name.ends_with?(".class")) %}
        {% unless subclass.resolve.instance_vars.empty? %}
          {% for instance_var in subclass.resolve.instance_vars %}
            {% stored_instance_var = {instance_var.name.stringify, instance_var.type.stringify} %}
            reflected_instance_vars << [ {{ stored_instance_var }} ]
          {% end %}
        {% end %}
      {% end %}
    {% end %}
    reflected_instance_vars
  end

  # Get all methods for each class.
  def self.reflect_methods : Array(MethodsArray)
    reflected_methods = [] of MethodsArray
    {% for subclass in Object.all_subclasses %}
      {% if subclass.name.starts_with?(::CRUML_FILTER_PREFIX) && !(subclass.name.ends_with?(".class")) %}
        {% unless subclass.methods.size == 0 %}
          # Store for each method : scope, name and return type.
          {% stored_methods = [] of Tuple(Symbol, String, String) %}
          {% for method in subclass.methods %}
            {% return_type = method.return_type.stringify.empty? ? "Nil" : method.return_type.stringify %}
            {% if method.name.stringify == "initialize" %}
              # Add the "initialize" method at the first element of the array.
              {% stored_methods.unshift({method.visibility, method.name.stringify, return_type}) %}
            {% else %}
              # Add other methods at the last element of the array.
              {% stored_methods << {method.visibility, method.name.stringify, return_type} %}
            {% end %}
          {% end %}
          reflected_methods << {{ stored_methods }}
        {% end %}
      {% end %}
    {% end %}
    reflected_methods
  end
end
