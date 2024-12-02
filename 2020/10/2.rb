class Node
  attr_accessor :value
  attr_accessor :succs
  def initialize(value)
    @value = value
  end

  def count_path
    @path_count ||= begin
      @succs.empty? ? 1 : @succs.collect(&:count_path).reduce(:+)
    end
  end
end

d = File.read('./input').each_line.collect(&:to_i).sort
d.unshift(0)
d.push(d.last + 3)
diff = d.each_cons(2).collect { |a, b| b - a }
t = diff.tally
puts t[1] * t[3]

graph = d.collect { |a| Node.new(a) }
graph.each { |n|
  n.succs = graph.select { |m| m.value <= n.value + 3 && m.value > n.value }
}
puts graph.first.count_path
