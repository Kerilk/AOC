require 'matrix'
require 'set'

pt = Vector.zero(2)
ph = Vector.zero(2)
vec_map = { "R" => Vector[1, 0], "L" => Vector[-1, 0],  "U" => Vector[0, 1], "D" => Vector[0, -1] }
tail_pos = Set.new
tail_pos.add(pt)

File.foreach("input").map { |l| l.match(/(R|L|U|D) (\d+)/).captures }.each { |d, c|
  c = c.to_i
  v = vec_map[d]
  c.times {
    ph += v
    d = ph-pt
    if d[0].abs > 1 || d[1].abs > 1
      (0..1).each { |i| d[i] /= d[i].abs if d[i].abs > 1 }
      pt += d
    end
    tail_pos.add(pt)
  }
}
p tail_pos.size
