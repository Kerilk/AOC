require 'pp'
digits = { 0 => "abcefg", 1 => "cf", 2 => "acdeg", 3 => "acdfg", 4 => "bcdf",
           5 => "abdfg", 6 => "abdefg", 7 => "acf", 8 => "abcdefg", 9 => "abcdfg" }
digits_map = ("a".."g").each_with_index.to_h
digits_bin = digits.map { |k, v| [k, v.chars.reduce(0) { |memo, c| memo += 1 << digits_map[c] }] }.to_h
d = File.open("input").each_line.map { |l| l.split("|") }.map { |i, o| [i.split, o.split] }
p remarquable_sizes = [1, 4, 7, 8].map { |v| digits[v].size }
p d.map { |_, o| o.map(&:size).select { |v| remarquable_sizes.include?(v) }.count }.sum
