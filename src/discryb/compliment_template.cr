require "yaml"

module Discryb
  class ComplimentTemplate
    getter base_templates : Array(String) = Array(String).new
    getter subtemplates : Hash(String, Array(String)) = Hash(String, Array(String)).new

    # TODO
    def initialize(@base_templates, @subtemplates)
    end

    # TODO
    def self.from_yaml(string_or_io : String | IO)
      templates = Hash(String, Array(String)).from_yaml string_or_io

      if templates["compliments"]?.nil?
        raise "Compliment templates YAML must include top-level 'compliments' element!"
      end

      base_templates = templates["compliments"]

      templates.delete "compliments"

      new base_templates, templates
    end

    # TODO
    def valid?
      subtemplate_keys = subtemplates.keys
      all_templates = base_templates + subtemplates.values.flatten

      all_templates.each do |template|
        template.scan /<([^>]+)>/ do |match|
          match.captures.each do |key|
            unless key.in? subtemplate_keys
              return false
            end
          end
        end
      end

      true
    end
  end
end
