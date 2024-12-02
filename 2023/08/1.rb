steps, map = File.read('input').split("\n\n").then { |s, m|
  [ s.chars,
    m.lines.map { |l| l.scan(/\w+/).then { |n, l, r| [n, {"L" => l, "R" => r}] } }.to_h ]
}

node = "AAA"
p steps.cycle.with_index(1) { |inst, i|
  node = map[node][inst]
  break i if node == "ZZZ"
}

nodes = map.keys.select { |n| n[-1] == 'A' }
p nodes.map { |node|
  cycle = steps.cycle.with_index(1) { |inst, i|
    node = map[node][inst]
    break i if i % steps.size == 0 && node[-1] == 'Z'
  }
  cycle/steps.size
}.reduce(:*)*steps.size

