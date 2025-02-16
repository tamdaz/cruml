# A reflection consists of retrieving infos on classes,
# which contain infos on instance variables, methods and arguments.
# This reflection principle is inspired by the `Reflection` class in the PHP language.
# - Reflection : https://www.php.net/manual/en/class.reflection.php
# - ReflectionClass : https://www.php.net/manual/en/class.reflectionclass.php
module Cruml::Reflection
  # Allows to process reflected classes.
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
          {{ subclass.name.stringify.gsub(/[()]/, "~") }},
          {{ class_type }}
        )

        {% for inherit_class in subclass.subclasses %}
          class_info.add_inherit_class(
            {{ subclass.name.stringify.gsub(/[()]/, "~") }},
            {{ inherit_class.name.stringify.gsub(/[()]/, "~") }}
          )
        {% end %}

        {% for instance_var in subclass.resolve.instance_vars %}
          class_info.add_instance_var(
            {{ instance_var.name.stringify.gsub(/[()]/, "~") }},
            {{ instance_var.type.stringify.gsub(/[()]/, "~") }}
          )
        {% end %}

        {% for method in subclass.resolve.methods %}
          method_info = Cruml::Entities::MethodInfo.new(
            {{ method.visibility }},
            {{ method.name.stringify }},
            {{ method.return_type.stringify.empty? ? "Nil" : method.return_type.stringify }}
          )

          {% for arg in method.args %}
            method_info.add_arg(
              Cruml::Entities::ArgInfo.new(
                {{ arg.name.stringify.gsub(/[()]/, "~") }},
                {{ arg.restriction.stringify.gsub(/[()]/, "~") }}
              )
            )
          {% end %}

          class_info.add_method(method_info)
        {% end %}
        class_list.add(class_info)
      {% end %}
    {% end %}
    class_list
  end
end
