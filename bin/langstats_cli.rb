require 'optparse'
require_relative "../lib/http_data_source"
require_relative "../lib/langstats_facade"

class LangstatsCLI
  private

  def self.parse_cli_args
    options = {}

    OptParse.new do |parser|
      parser.banner = "Usage: cli_controller.rb -o ORGANIZATION [-u USER[:PASSWORD]]"

      parser.on("-o", "--organization ORGANIZATION", "The name of the organization") do |v|
        options[:organization] = v
      end

      parser.on("-u", "--user USER[:PASSWORD]", "Data source user and password") do |v|
        options[:user] = v
      end

      parser.on("-h", "--help", "Print this help") do
        puts parser
        exit
      end
    end.parse!

    if options[:organization].nil?
      raise OptParse::MissingArgument, "Missing -o option is mandatory. Use --help for more information"
    end

    options
  end

  def self.sort_lang_stats(langstats_hash)
    langstats_hash.to_a.sort do |lang_stat_a, lang_stat_b|
      lang_stat_b[1] <=> lang_stat_a[1]
    end
  end

  def self.produce_json(organization, langstats_hash)
    string_buffer = "{\n\s\s\"organization\": " + organization + ",\n"
    string_buffer << "\s\s\"languages\": {"
    langstats_hash.each do |lang_stat|
      string_buffer << "\n\s\s\s\s\"" + lang_stat[0] + "\": " + lang_stat[1].round(2).to_s + ","
    end
    string_buffer = string_buffer.chop
    string_buffer << "\n\s\s}"
    string_buffer << "\n}"
    puts string_buffer
  end

  def self.main
    options = parse_cli_args
    organization = options[:organization]
    if options[:user]
      user_args = options[:user].split(':')
      username = user_args[0]
      password = user_args[1]
    end

    facade = LangstatsFacade.new(HTTPDataSource.new)
    lang_stats = facade.get_lang_stats(organization, username, password)
    sorted_lang_stats = sort_lang_stats(lang_stats)
    produce_json(organization, sorted_lang_stats)
  end

  begin
    main
  rescue StandardError => e
    $stderr.puts(e.to_s)
    exit(1)
  end
end
