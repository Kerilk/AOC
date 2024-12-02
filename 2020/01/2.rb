data = File.read("./input").lines.collect { |s| s.to_i }
puts data.combination(3).find { |c| c.reduce(:+) == 2020 }.reduce(:*)
