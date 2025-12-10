require 'matrix'

tiles = File.read('input').each_line.map { |l| Vector[*l.split(',').map(&:to_i)] }
x_map, y_map = tiles.map(&:to_a).transpose.map(&:sort).map(&:uniq).map(&:each_with_index).map(&:to_h)
remapped_tiles = tiles.map { |p| Vector[1 + x_map[p[0]]*2, 1 + y_map[p[1]]*2] }
segments = remapped_tiles.each_cons(2).to_a << [remapped_tiles.last, remapped_tiles.first]

xmax = 1 + x_map.values.max*2 + 2
ymax = 1 + y_map.values.max*2 + 2

field = Matrix.build(xmax, ymax) { 2 }
segments.each { |p1, p2|
  Range.new(*[p1[0], p2[0]].sort).each { |i|
    Range.new(*[p1[1], p2[1]].sort).each { |j|
      field[i, j] = 1
    }
  }
}

queue = [[0,0]]
field[0, 0] = 0
while e = queue.shift
  i, j = *e
  tests = []
  tests << [i+1,j  ] if i < xmax - 1
  tests << [i-1,j  ] if i > 1
  tests << [i  ,j+1] if j < ymax - 1
  tests << [i  ,j-1] if j > 1
  tests.each { |indices|
    if field[*indices] == 2
      field[*indices] = 0
      queue.push indices
    end
  }
end

p remapped_tiles.each_with_index.to_a.combination(2).select { |(p1, _), (p2, _)|
  ( [p1[0], p2[0]].product(Range.new(*[p1[1], p2[1]].sort).to_a) +
    Range.new(*[p1[0], p2[0]].sort).to_a.product([p1[1], p2[1]]) ).all? { |i, j| field[i, j] > 0 }
}.map { |(_, i1), (_, i2)| tiles[i2]-tiles[i1] }.map { |v| v.map(&:abs).map(&1.method(:+)).reduce(:*) }.max
