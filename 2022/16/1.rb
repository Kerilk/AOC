class Room
  attr_reader :name, :valve, :index
  attr_accessor :tunnels, :state, :in_tunnels

  def initialize(name, valve, index)
    @name, @valve, @index = name, valve, index
    @state = Hash.new { |h, k| h[k] = {} }
    @in_tunnels = []
  end

  def inspect
    "#{@name}(#{@valve}): -> #{@in_tunnels.map(&:name).join(", ")}"
  end

  def to_s(ts)
    str =  "#{@name}:\n"
    str << @state[ts].map { |t| "\t#{t.inspect}" }.join("\n") if @state[ts]
    str
  end
end

nodes = {}

File.foreach("input").map { |l|
  node, *tunnels = *l.scan(/[A-Z][A-Z]/)
  [[node, l.match(/\d+/)[0].to_i], [node, tunnels]]
}.transpose.yield_self { |nds, tns|
  nodes.merge! nds.each_with_index.map { |(name, valve), i| [name,  Room.new(name, valve, i)] }.to_h
  tns.each { |n, l|
    node = nodes[n]
    node.tunnels = l.map { |tn| nodes[tn] }
    node.tunnels.each { |target| target.in_tunnels.push node }
  }
}
# path, rate, total, projected
# projected = (30 - date)*rate + total
nodes["AA"].state[0][[false]*nodes.size] = [["AA"], 0, 0, 0]


puts nodes.values.map(&:inspect).join("\n")
max_rate = nodes.values.map(&:valve).sum
puts "Max rate = #{max_rate}"
limit = 30

1.upto(limit).each do |date|
#  puts "-------------------"
#  p date
#  puts nodes.values.map { |v| v.to_s(date-1) }.join("\n")
  nodes.values.each { |node|
    node.state[date-1].each { |valves, (path, rate, total, projected)|
      total += rate
      if !valves[node.index]
        rate += node.valve
        new_projected = (limit - date)*rate + total
        if (new_projected > projected)
          valves = valves.dup
          valves[node.index] = true
          projected = new_projected
          node.state[date][valves] = [path + ["*"], rate, total, projected]
        end
      end
    }
    node.in_tunnels.each { |source|
      source.state[date-1].each { |valves, (path, rate, total, projected)|
        total += rate
        if node.state[date][valves]
          if projected > node.state[date][valves].last
            node.state[date][valves] = [path + [node.name], rate, total, projected]
          end
        else
          node.state[date][valves] = [path + [node.name], rate, total, projected]
        end
      }
    }
    max = node.state[date].values.map(&:last).max
    node.state[date].reject! { |_, v| v[-2] + max_rate * (limit - date) < max }
  }
end

p nodes.each_value.filter_map { |n| n.state[limit].values.map(&:last).max if n.state[limit] }.max
