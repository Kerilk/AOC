stacks = Hash.new { |k, v| k[v] = [] }
state, instructions = File.read("input").split("\n\n").map(&:lines)
range = 1..(state.first.size / 4)
state[0..-2].reverse.each { |l|
  range.each { |i|
     stacks[i].push l[(i-1)*4 + 1] if l[(i-1)*4 + 1] != " "
  }
}
instructions.map { |i|
  i.match(/move (\d+) from (\d+) to (\d+)/)[1..3].map(&:to_i)
}.each { |a, s, d|
  stacks[d].append *stacks[s].pop(a)
}
puts range.map { |i| stacks[i].last }.join("")
