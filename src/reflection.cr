# ```text
# - Array of classes
#  - Classes (name only)
#   - Instance vars (name and type)
#   - Methods (scope, name and return type)
# ```
module Cruml::Reflection
  def self.start : Cruml::ClassList
    class_list = Cruml::ClassList.new
    {% for subclass in Object.all_subclasses %}
      {% contains_prefixed_name = subclass.name.starts_with?(::CRUML_FILTER_PREFIX) %}
      {% contains_suffixed_name = subclass.name.ends_with?(".class") || subclass.name.ends_with?(":Module") %}

      {% if contains_prefixed_name && !contains_suffixed_name %}
        {% class_type = :class if subclass.class? %}
        {% class_type = :abstract if subclass.abstract? %}
        {% class_type = :interface if subclass.annotation(Cruml::Annotation::AsInterface) %}

        class_info = Cruml::Entities::ClassInfo.new(
          {{ subclass.name.stringify }},
          {{ class_type }}
        )

        {% for inherit_class in subclass.subclasses %}
          class_info.add_inherit_class({{ subclass.name.stringify }}, {{ inherit_class.name.stringify }})
        {% end %}

        {% for instance_var in subclass.resolve.instance_vars %}
          class_info.add_instance_var(
            {{ instance_var.name.stringify }},
            {{ instance_var.type.stringify }}
          )
        {% end %}

        {% for method in subclass.resolve.methods %}
          method_info = Cruml::Entities::MethodInfo.new(
            {{ method.name.stringify }},
            {{ method.return_type.stringify.empty? ? "Nil" : method.return_type.stringify }}
          )

          class_info.add_method(method_info)
        {% end %}
        class_list.add(class_info)
      {% end %}
    {% end %}
    class_list
  end
end
