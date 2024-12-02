names = %w{one two three four five six seven eight nine}
nums = (1..9).map(&:to_s)
digits = (names.zip(nums) + nums.zip(nums)).to_h
regexp = /#{digits.keys.join("|")}/
regexp_end = /.*(#{digits.keys.join("|")})/

p File.read("input").
  each_line.
  map { |l| digits[l[regexp]] + digits[l.match(regexp_end)[1]] }.
  map(&:to_i).
  sum
