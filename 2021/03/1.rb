i = File.read("input").each_line.map(&:strip).map(&:chars)
count = i.size
length = i[0].size
gamma = i.reduce(Array.new(length, 0)) { |memo, num| num.each_with_index { |c, i| memo[i] += (c == "1" ? 1 : 0) }; memo }.reduce("") { |memo, e| memo << (e >= count - e ? "1" : "0") }
epsilon = gamma.chars.reduce("") { |memo, e| memo << (e == "1" ? "0" : "1") }
p gamma.to_i(2)*epsilon.to_i(2)
