require "../src/discryb/*"

if ARGV.size < 1
  puts "ERROR: Must pass in a compliment template file!"
  exit(1)
end

if ARGV.size > 2
  puts "WARNING: only the first argument is used!"
end

filename = ARGV[0]
compliments = nil

File.open filename do |file|
  compliments = Discryb::ComplimentTemplate.from_yaml file
end

if (compl_template = compliments)
  puts compl_template.all_instantiations.join '\n'
end
