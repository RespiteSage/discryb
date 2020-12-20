require "option_parser"

require "./discryb/compliment_template"

module Discryb
  class_property secret : String = ""
  class_property compliments : ComplimentTemplate? = nil

  def self.configure
    OptionParser.parse do |parser|
      parser.banner = "Usage: discryb -s [secret]"
      parser.separator

      parser.on "-s [secret]", "Secret to use as a Discord bot" do |secret|
        self.secret = secret
      end

      parser.on "-c [YAML file]", "YAML file containing a compliment template" do |filename|
        File.open filename do |file|
          self.compliments = ComplimentTemplate.from_yaml file
        end
      end

      parser.on "-h", "--help", "Display this help" do
        puts parser
        exit status: 0
      end
    end

    if self.secret.empty?
      puts "A secret is required to run this bot!"
      exit 1
    end
  end
end
