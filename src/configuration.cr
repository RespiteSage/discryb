require "option_parser"

module Discryb
  class_property secret : String = ""

  def self.configure
    OptionParser.parse do |parser|
      parser.banner = "Usage: discryb -s [secret]"
      parser.separator

      parser.on "-s [secret]", "Secret to use as a Discord bot" do |secret|
        self.secret = secret
      end
    end
  end
end
