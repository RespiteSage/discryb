require "yaml"
require "random"

module Discryb
  class ComplimentTemplate
    getter base_templates : Array(String) = Array(String).new
    getter subtemplates : Hash(String, Array(String)) = Hash(String, Array(String)).new
    private getter random_state : Random

    # TODO
    def initialize(@base_templates, @subtemplates, seed = nil)
      if seed
        @random_state = Random.new seed
      else
        @random_state = Random::DEFAULT
      end
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

    # TODO
    def generate_compliment
      instantiate_template base_templates.sample(1, random_state)
    end

    def instantiate_template(template : String)
      until (subtemplate_matches = template.scan /(<([^>]+)>)/).empty?
        subtemplate_matches.each do |match|
          subtemplate_tag = match.captures[0]
          subtemplate_key = match.captures[1]

          subtemplate_value = subtemplates[subtemplate_key].sample(1, random_state)

          template = template.sub subtemplate_tag, subtemplate_value
        end
      end
      template
    end
  end
end
