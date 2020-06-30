require "http"
require "openssl"
require "json"

require "discordcr"

require "./configuration"

# TODO: Write documentation for `Discord::Compliment::Bot`
module Discryb
  VERSION = "0.1.0"

  SSL_CONTEXT = OpenSSL::SSL::Context::Client.new

  def self.get_compliment : String
    response = HTTP::Client.get "https://complimentr.com/api", tls: SSL_CONTEXT
    JSON.parse(response.body)["compliment"].to_s
  end
end

Discryb.configure

puts Discryb.get_compliment

puts Discryb.secret
