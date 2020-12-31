require "yaml"
require "random"

module Discryb
  # A `ComplimentTemplate` contains templates that are used to form compliment
  # strings.
  #
  # The top-level compliments are in `#base_templates`, and they are instantiated
  # using the subtemplates and strings in `#subtemplates`.
  class ComplimentTemplate
    getter base_templates : Array(String) = Array(String).new
    getter subtemplates : Hash(String, Array(String)) = Hash(String, Array(String)).new
    private getter random_state : Random

    # Creates a new ComplimentTemplate with the given base templates and subtemplates
    def initialize(@base_templates, @subtemplates, seed = nil)
      if seed
        @random_state = Random.new seed
      else
        @random_state = Random::DEFAULT
      end
    end

    # Creates a new ComplimentTemplate from the given YAML string or IO
    def self.from_yaml(string_or_io : String | IO)
      templates = Hash(String, Array(String)).from_yaml string_or_io

      if templates["compliments"]?.nil?
        raise "Compliment templates YAML must include top-level 'compliments' element!"
      end

      base_templates = templates["compliments"]

      templates.delete "compliments"

      new base_templates, templates
    end

    # Returns true if all templates will instantiate into concrete strings,
    # otherwise returns false
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

    # Randomly generates a compliment from the base templates
    def generate_compliment
      instantiate_template base_templates.sample(1, random_state).first
    end

    # Randomly turns a compliment template into a concrete string through repeated
    # substitution
    def instantiate_template(template : String)
      until (subtemplate_matches = template.scan /(<([^>]+)>)/).empty?
        subtemplate_matches.each do |match|
          # I'm not sure if the .not_nil! here is safe... probably?
          subtemplate_tag = match.captures[0].not_nil!
          subtemplate_key = match.captures[1].not_nil!

          subtemplate_value = subtemplates[subtemplate_key].sample(1, random_state).first

          template = template.sub subtemplate_tag, subtemplate_value
        end
      end
      template
    end

    # Outputs all possible instantiations of all base templates
    def all_instantiations
      instantiations = base_templates.clone
      instantiations.flat_map do |template|
        template_instantiations template
      end
    end

    private def template_instantiations(template : String) : Array(String)
      instantiations = Array(String).new
      if (subtemplate_matches = template.scan /(<([^>]+)>)/).empty?
        instantiations << template
      else
        match = subtemplate_matches.first
        subtemplate_tag = match.captures[0].not_nil!
        subtemplate_key = match.captures[1].not_nil!

        subtemplate_values = subtemplates[subtemplate_key]

        partial_instantiations = subtemplate_values.map { |value| template.sub subtemplate_tag, value }

        instantiations += partial_instantiations.flat_map { |partial| template_instantiations partial }
      end
      instantiations
    end
  end
end
