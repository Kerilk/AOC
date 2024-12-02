require 'prime'
steps, map = File.read('input').split("\n\n").then { |s, m|
  [
    s.chars,
    m.lines.map { |l| l.scan(/\w+/).then { |n, l, r| [n, {"L" => l, "R" => r}] } }.to_h
  ]
}
nodes = map.keys.select { |n| n[-1] == 'A' }
p nodes.map { |node|
  path = []
  cycle = steps.cycle.with_index(1) { |inst, i|
    node = map[node][inst]
    path.push node
    break i if i % steps.size == 0 && node[-1] == 'Z'
  }
#  p [cycle, Prime.prime_division(cycle), path.each.with_index(1).find { |v, _| v[-1] == 'Z' } ]
  cycle/steps.size
}.reduce(:*)*steps.size
exit

targets = map.keys.select { |n| n[-1] == 'Z' }
p steps.cycle.with_index(1) { |inst, i|
  nodes = nodes.map { |n| map[n][inst] }
  break i if (nodes-targets).empty?
}
