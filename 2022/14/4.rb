require 'set'
require 'matrix'

source = [500, 0]
paths = File.foreach("input").map { |l| l.split(" -> ").map { |s| s.split(",").map(&:to_i) } }
i_min, i_max, j_min, j_max = (paths.flatten(1) + [source]).transpose.map(&:minmax).flatten
j_max = j_max + 2
i_min = [i_min, 500 - j_max].min
map = Matrix.build(500 - i_min + j_max + 1, j_max) { false }
paths.each { |path|
  path.each_cons(2).map(&:transpose).map { |coord|
    coord.map(&:sort)
  }.each { |(i1, i2), (j1, j2)| 
    (i1..i2).each { |i| (j1..j2).each { |j| map[i - i_min, j] = "#" } }
  }
}
is, js = 500 - i_min, 0
map[is, js] = "o"
(1..(j_max-1)).each { |j|
  ((1 - j_max + j)..(500 - i_min + j)).each { |i|
    map[i, j] = "o" if !map[i, j] && (map[i, j-1] == "o" || map[i-1, j-1] == "o" || map[i+1, j-1] == "o")
  }
}
puts map.each.filter { |e| e == "o" }.count
