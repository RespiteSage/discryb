require "http"
require "openssl"
require "json"

# TODO: Write documentation for `Discord::Compliment::Bot`
module Compliments
  VERSION = "0.1.0"

  SSL_CONTEXT = OpenSSL::SSL::Context::Client.new

  def self.get_compliment : String
    response = HTTP::Client.get "https://complimentr.com/api", tls: SSL_CONTEXT
    JSON.parse(response.body)["compliment"].to_s
  end
end

puts Compliments.get_compliment
