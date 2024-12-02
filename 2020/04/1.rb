mandatory_fields = [
  "byr",
  "iyr",
  "eyr",
  "hgt",
  "hcl",
  "ecl",
  "pid" ]
optional_fields = [
  "cid" ]

data = File.read("input").split("\n\n").collect { |block|
  block.split.collect { |entry|
    entry.split(":")
  }.to_h
}

valid = 0
data.each { |d|
  is_valid = true
  mandatory_fields.each { |f| is_valid = false unless d[f] }
  valid += 1 if is_valid
}
puts data.size
puts valid
