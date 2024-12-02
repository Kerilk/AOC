require 'set'
nodes = nil
tunnels = {}

File.foreach("input").map { |l|
  node, *tns = *l.scan(/[A-Z][A-Z]/).map(&:to_sym)
  [[node, l.match(/\d+/)[0].to_i], [node, tns]]
}.transpose.yield_self { |nds, tns|
  nodes = nds.each_with_index.filter_map { |(name, valve), i| [name,  valve] if valve > 0 }.to_h
  tns.each { |n, l|
    tunnels[n] = l
  }
}

max_rate = nodes.values.sum
limit = 26
old_states = {[Set[:AA, :AA], Set.new] => [0, 0, 0]}
new_states = {}

1.upto(limit).each do |date|
  old_states.each { |(pos, valves), (rate, total, projected)|
    total += rate
    p1, p2 = *pos.to_a
    p2 = p1 unless p2
    valve1 = nodes[p1]
    valve2 = nodes[p2]
    actions1 = tunnels[p1]
    actions1 += [p1] if valve1 && !valves.include?(p1)
    actions2 = tunnels[p2]
    actions2 += [p2] if valve2 && p1 != p2 && !valves.include?(p2)
    actions1.product(actions2).each { |a1, a2|
      new_rate = rate
      new_valves = valves.dup
      if a1 == p1
        new_rate += valve1
        new_valves.add(p1)
      end
      if a2 == p2
        new_rate += valve2
        new_valves.add(p2)
      end
      new_projected = total + (limit - date)*new_rate
      key = [Set[a1, a2], new_valves]
      s = new_states[key]
      new_states[key] = [new_rate, total, new_projected] unless s && s.last >= new_projected
    }
  }
  max = new_states.values.map(&:last).max
  new_states.reject! { |_, (_, total, _)| total + max_rate * (limit - date) < max }
  new_states, old_states = {}, new_states
end

p old_states.filter_map { |_, (_, total, _)| total }.max
