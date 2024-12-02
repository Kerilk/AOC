require 'matrix'
require 'set'

rope_size = 10
positions = rope_size.times.map { Vector.zero(2) }
dir_map = { "R" => Vector[1, 0], "L" => Vector[-1, 0],  "U" => Vector[0, 1], "D" => Vector[0, -1] }
tail_positions = Set[positions.last]

File.foreach("input").map { |l| l.match(/(R|L|U|D) (\d+)/).captures }.map { |dir, count|
  [dir_map[dir], count.to_i]
}.each { |vec, count|
  count.times {
    positions[0] += vec
    (0...rope_size).each_cons(2) { |s1, s2|
      delta = positions[s1]-positions[s2]
      if delta[0].abs > 1 || delta[1].abs > 1
        (0..1).each { |i| delta[i] /= delta[i].abs if delta[i].abs > 1 }
        positions[s2] += delta
      end
    }
    tail_positions.add(positions.last)
  }
}
p tail_positions.size
