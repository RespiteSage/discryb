require "yaml"

module Discryb
  class ComplimentTemplate
    getter base_templates : Array(String) = Array(String).new
    getter secondary_templates : Hash(String, Array(String)) = Hash(String, Array(String)).new

    # TODO
    def initialize(@base_templates, @secondary_templates)
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
  end
end
