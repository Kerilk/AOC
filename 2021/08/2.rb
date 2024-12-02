require 'set'
digits =
{ 0 => "abcefg",
  1 => "cf",
  2 => "acdeg",
  3 => "acdfg",
  4 => "bcdf",
  5 => "abdfg",
  6 => "abdefg",
  7 => "acf",
  8 => "abcdefg",
  9 => "abcdfg" }.map { |k, v| [k, v.chars.to_set] }.to_h

remarquable_sizes = digits.values.map(&:size).tally.select { |_, v| v == 1}.keys
segments_count = digits.values.map(&:to_a).reduce(:+).tally
remarquable_count_segment = segments_count.select { |k, v| segments_count.values.tally[v] == 1 }.invert
print = digits.invert

size_segments = Hash.new { |k, v| k[v] = Set.new }
digits.each { |k, v| size_segments[v.size].merge(v) }

d = File.open("input").each_line.map { |l| l.split("|") }.map { |i, o| [i.split, o.split] }

p d.map { |_, o| o.map(&:size).select { |v| remarquable_sizes.include?(v) }.count }.sum

p d.map { |i, o|
  found_mapping = {}
  # Use wires that have a uniq count
  i.reduce(&:+).chars.tally.each { |k, v| found_mapping[k] = remarquable_count_segment[v] if remarquable_count_segment[v] }
  # create first mapping by using the number of segments
  prob_digits = i.map { |v| [v.chars, size_segments[v.size]] }.to_h
  possible_mapping = ("a".."g").map { |c| [c, prob_digits.select { |digit, _| digit.include?(c) }.values.reduce(:&)] }.to_h
  #transitive closure
  while found_mapping.size < 7
    possible_mapping.select { |k, v| v.size == 1}.each { |k, v| found_mapping[k] = v.first }
    found_mapping.each_key { |k| possible_mapping.delete(k) }
    found_mapping.each_value { |v| possible_mapping.each_value { |l| l.delete(v) } }
  end
  o.collect { |v| print[v.chars.collect { |c| found_mapping[c] }.to_set] }.join.to_i
}.sum
