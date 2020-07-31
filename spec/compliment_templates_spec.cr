require "./spec_helper"

describe ComplimentTemplate do
  describe ".new" do
    it "creates a new ComplimentTemplate with the given base and secondary templates" do
      base_templates = ["You're so <positive_adjective>!", "Wow, I bet you could <difficult_action>!"]
      secondary_templates = {"positive_adjective" => ["handy", "benevolent"],
                             "difficult_action"   => ["touch your nose with your tongue", "climb a big wall"]}

      result = ComplimentTemplate.new base_templates, secondary_templates

      result.base_templates.should eq base_templates
      result.secondary_templates.should eq secondary_templates
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
      secondary_templates = {"adjective"  => ["disastrous", "somber", "pulchritudinous"],
                             "heroic_job" => ["firefighter", "paramedic", "doctor"],
                             "disaster"   => ["fire", "nuclear meltdown", "famine"]}

      result = ComplimentTemplate.from_yaml yaml

      result.base_templates.should eq base_templates
      result.secondary_templates.should eq secondary_templates
    end
  end
end
