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

  def self.create_client
    client_id = 727388592770646078u64
    client = Discord::Client.new(token: self.secret)
  end

  def self.run
    client = self.create_client

    client.on_message_create do |payload|
      if payload.content.starts_with? "!compliment"
        puts "Message: '#{payload.content}'"
        puts "Invoking a compliment!"
        message = payload.content.split " "
        reply = nil
        if message.size == 1 && message[0] == "!compliment"
          user = payload.author.username
          reply = "@#{user} #{self.get_compliment}"
        elsif message.size == 2
          user = message[1]
          reply = "#{user}, #{self.get_compliment}"
        end
        if reply
          channel_id = payload.channel_id
          client.create_message(channel_id, reply)
        end
      end
    end

    client.run
  end
end

Discryb.configure

Discryb.run
