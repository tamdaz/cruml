# This consists of obtaining information about methods.
class Cruml::Entities::MethodInfo
  # Method visibility (-, # and +).
  getter visibility : Symbol

  # Method name.
  getter name : String

  # Return type of a method.
  getter return_type : String

  # All arguments in a method.
  getter args = [] of Cruml::Entities::ArgInfo

  def initialize(@visibility : Symbol, @name : String, @return_type : String); end

  # Add an argument into the args list.
  def add_arg(arg : Cruml::Entities::ArgInfo)
    @args << arg

    if Cruml::Renders::Config.verbose? == true
      puts "VERBOSE : #{arg.name.colorize(:magenta)} arg of type #{arg.type.colorize(:magenta)} added to #{@name.colorize(:magenta)} method."
    end
  end

  # Generate the args.
  def generate_args : String
    String.build do |str|
      @args.each_with_index do |arg, i|
        patterns = {
          '|' => "\\|",
          ':' => "\\:",
          '.' => "\\.",
          '{' => "\\{",
          '}' => "\\}",
          '<' => "\\<",
          '[' => "\\[",
          ']' => "\\]",
        }

        str << "#{arg.name} \\: #{arg.type.gsub(patterns)}"
        if i != @args.size - 1
          str << ", "
        end
      end
    end
  end
end
