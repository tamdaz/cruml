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
  end

  # Generate the args.
  def generate_args : String
    String.build do |str|
      @args.each_with_index do |arg, i|
        str << "#{arg.name} : #{arg.type}"
        str << ", " if i != @args.size - 1
      end
    end
  end
end
