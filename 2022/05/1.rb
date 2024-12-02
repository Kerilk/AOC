stacks = Hash.new { |k, v| k[v] = [] }
state, instructions = File.read("input").split("\n\n").map(&:lines)
size = state.first.size / 4
state[0..-2].reverse.each { |l| (1..size).each { |i| stacks[i].push l[(i-1)*4 + 1] if l[(i-1)*4 + 1] != " " } }
instructions.map { |i| i.match(/move (\d+) from (\d+) to (\d+)/)[1..3].map(&:to_i) }.each { |a, s, d| a.times { stacks[d].push stacks[s].pop } }
puts (1..size).map { |i| stacks[i].last }.join("")
