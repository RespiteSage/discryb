require "./spec_helper"

describe ComplimentTemplate do
  describe ".new" do
    it "creates a new ComplimentTemplate with the given base and secondary templates" do
      base_templates = ["You're so <positive_adjective>!", "Wow, I bet you could <difficult_action>!"]
      subtemplates = {"positive_adjective" => ["handy", "benevolent"],
                      "difficult_action"   => ["touch your nose with your tongue", "climb a big wall"]}

      result = ComplimentTemplate.new base_templates, subtemplates

      result.base_templates.should eq base_templates
      result.subtemplates.should eq subtemplates
    end
  end

  describe ".from_yaml" do
    it "creates a new ComplimentTemplate from equivalent YAML" do
      yaml = <<-YAML
                ---
                compliments:
                  - I wish I could be as <adjective> as you!
                  - Are you a <heroic_job>? Because you really saved me from a <disaster>!

                adjective:
                  - disastrous
                  - somber
                  - pulchritudinous

                heroic_job:
                  - firefighter
                  - paramedic
                  - doctor

                disaster:
                  - fire
                  - nuclear meltdown
                  - famine
                YAML

      base_templates = ["I wish I could be as <adjective> as you!", "Are you a <heroic_job>? Because you really saved me from a <disaster>!"]
      subtemplates = {"adjective"  => ["disastrous", "somber", "pulchritudinous"],
                      "heroic_job" => ["firefighter", "paramedic", "doctor"],
                      "disaster"   => ["fire", "nuclear meltdown", "famine"]}

      result = ComplimentTemplate.from_yaml yaml

      result.base_templates.should eq base_templates
      result.subtemplates.should eq subtemplates
    end
  end

  describe "#valid?" do
    it "returns true for a valid template" do
      base_templates = ["You're so <positive_adjective>!", "Wow, I bet you could <difficult_action>!"]
      subtemplates = {"positive_adjective" => ["handy", "benevolent"],
                      "difficult_action"   => ["touch your nose with your tongue", "climb a big wall"]}

      result = ComplimentTemplate.new base_templates, subtemplates

      result.valid?.should be_true
    end

    it "returns false for a template with missing subtemplates" do
      base_templates = ["You're so <positive_adjective>!", "Wow, I bet you could <difficult_action>!"]
      subtemplates = {"positive_adjective" => ["handy", "benevolent", "charming", "lovely"]}

      result = ComplimentTemplate.new base_templates, subtemplates

      result.valid?.should be_false
    end
  end

  describe "#instantiate_template" do
    it "replaces subtemplate tags with values from those subtemplates" do
      base_templates = ["You're so <positive_adjective>!", "Wow, I bet you could <difficult_action>!"]
      subtemplates = {"positive_adjective" => ["handy", "benevolent", "charming", "lovely"],
                      "difficult_action"   => ["touch your nose with your tongue", "climb a big wall"]}

      template = ComplimentTemplate.new base_templates, subtemplates, seed: 0

      result = template.instantiate_template base_templates.first

      result.should eq "You're so handy!"
    end

    it "uses different values on subsequent calls" do
      base_templates = ["You're so <positive_adjective>!", "Wow, I bet you could <difficult_action>!"]
      subtemplates = {"positive_adjective" => ["handy", "benevolent", "charming", "lovely"],
                      "difficult_action"   => ["touch your nose with your tongue", "climb a big wall"]}

      template = ComplimentTemplate.new base_templates, subtemplates, seed: 0

      first_result = template.instantiate_template base_templates.first
      second_result = template.instantiate_template base_templates.first

      first_result.should eq "You're so handy!"
      second_result.should eq "You're so charming!"
    end
  end

  describe "#generate_compliment" do
    it "generates a compliment from the templates and subtemplates" do
      base_templates = ["You're so <positive_adjective>!", "Wow, I bet you could <difficult_action>!"]
      subtemplates = {"positive_adjective" => ["handy", "benevolent", "charming", "lovely"],
                      "difficult_action"   => ["touch your nose with your tongue", "climb a big wall"]}

      template = ComplimentTemplate.new base_templates, subtemplates, seed: 0

      result = template.generate_compliment

      result.should eq "You're so charming!"
    end

    it "uses different values on subsequent calls" do
      base_templates = ["You're so <positive_adjective>!", "Wow, I bet you could <difficult_action>!"]
      subtemplates = {"positive_adjective" => ["handy", "benevolent", "charming", "lovely"],
                      "difficult_action"   => ["touch your nose with your tongue", "climb a big wall"]}

      template = ComplimentTemplate.new base_templates, subtemplates, seed: 0

      first_result = template.generate_compliment
      second_result = template.generate_compliment

      first_result.should eq "You're so charming!"
      second_result.should eq "Wow, I bet you could touch your nose with your tongue!"
    end
  end
end
