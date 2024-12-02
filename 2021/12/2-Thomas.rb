require 'set'
data = File.read("input")
h = {}
data = data.split("\n").map{ |l|
  a, b = l.split('-')
  a, b = b, a if b == "start" || a == "end"
  (h[a] ||= Set.new).add(b)
  (h[b] ||= Set.new).add(a) if a != "start" && b != "end"
}

$c = {}
def f(h, node, small_cave = Set.new, double = false)
  return 1 if node == "end"
  small_cave_u = node == node.downcase ? small_cave.dup.add(node) : small_cave
  $c[ [node, small_cave, double] ] ||= h[node].sum { |x|
    inc = small_cave_u.include?(x)
    !(inc && double) ? f(h, x, small_cave_u, double || inc) : 0
  }
end

p f(h, "start")
