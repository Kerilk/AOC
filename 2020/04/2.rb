mandatory_fields = {
  "byr" => [/\A(\d\d\d\d)\z/, lambda { |m| (1920..2002).include?(m[1].to_i) }],
  "iyr" => [/\A(\d\d\d\d)\z/, lambda { |m| (2010..2020).include?(m[1].to_i) }],
  "eyr" => [/\A(\d\d\d\d)\z/, lambda { |m| (2020..2030).include?(m[1].to_i) }],
  "hgt" => [/\A(\d+)(in|cm)\z/, lambda { |m| m[2] == "cm" ? (150..193).include?(m[1].to_i) : (59..76).include?(m[1].to_i) }],
  "hcl" => [/\A#\h{6}\z/],
  "ecl" => [/amb|blu|brn|gry|grn|hzl|oth/],
  "pid" => [/\A\d{9}\z/] }
optional_fields = [
  "cid" ]

data = File.read("input").split("\n\n").collect { |block|
  block.split.collect { |entry|
    entry.split(":")
  }.to_h
}

valid = data.count { |d|
  mandatory_fields.collect { |f, validator|
    (datum = d[f]) && (m = datum.match(validator[0])) && (validator[1] ? validator[1].call(m) : true)
  }.reduce(:&)
}
puts data.size
puts valid
