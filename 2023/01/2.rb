names = %w{one two three four five six seven eight nine}
nums = (1..9).map(&:to_s)
digits = (names.zip(nums) + nums.zip(nums)).to_h
rdigits = digits.transform_keys(&:reverse)
regexp = /#{digits.keys.join("|")}/
rregexp = /#{rdigits.keys.join("|")}/

p File.read("input").each_line.
  map { |l| digits[l[regexp]] + rdigits[l.reverse[rregexp]] }.
  sum(&:to_i)
