digits = {
  0 => "abcefg",
  1 => "cf",
  2 => "acdeg",
  3 => "acdfg",
  4 => "bcdf",
  5 => "abdfg",
  6 => "abdefg",
  7 => "acf",
  8 => "abcdefg",
  9 => "abcdfg" }
freqs_ref = digits.values.reduce(:+).chars.tally
digit_map = digits.transform_values { |v| v.chars.collect { |c| freqs_ref[c] }.sum }.invert
d = File.open("input").each_line.map { |l| l.split("|").map(&:split) }
p d.map { |input, output|
  freqs = input.reduce(:+).chars.tally
  output.collect { |v| digit_map[v.chars.collect { |c| freqs[c] }.sum] }.join.to_i
}.sum
