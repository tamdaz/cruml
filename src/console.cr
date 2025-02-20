require "option_parser"
require "./transformer"
require "./renders/diagram_render"

files = [] of String
verbose = false
dark_mode = false

OptionParser.parse do |parser|
  parser.banner = "Usage : cruml [subcommand] [arguments] -- [options]"

  parser.on "generate", "Generate the class diagram" do
    parser.banner = "Usage : cruml generate [arguments] -- [options]"

    parser.on "--verbose", "Enable verbose" { verbose = true }
    parser.on "--dark-mode", "Set to dark mode" { dark_mode = true }

    parser.on "--path=PATH", "Path to specify" do |path|
      files << path if File.file?(path) && path.ends_with?(".cr")
      files |= Dir.glob("#{path}/**/*.cr") if File.directory?(path)
    end
  end

  parser.on "-v", "--version", "Show the version" do
    puts "Cruml (version #{Cruml::VERSION})"
    exit 0
  end

  parser.on "-h", "--help", "Show this help" do
    puts parser
    exit 0
  end

  parser.invalid_option do |flag|
    STDERR.puts "\e[31mERROR: #{flag} is not a valid option.\e[0m"
    STDERR.puts parser
    exit 1
  end
end

if files.size == 0
  puts "No crystal files are present in the path, please retry."
  exit 1
end

files.each do |file|
  ast = Crystal::Parser.parse(File.read(file))
  tx = Cruml::Transformer.new
  ast.transform(tx)
end

Cruml::ClassList.verify_instance_var_duplication

Cruml::Renders::DiagramRender.new("out/diagram.html").save
