# This consists of obtaining information about methods.
class Cruml::Entities::MethodInfo
  getter visibility : Symbol
  getter name : String
  getter return_type : String
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
        str << "#{arg.name} \\: #{arg.type.gsub("|", "\\|")}"
        str << ", " if i != @args.size - 1
      end
    end
  end
end
