require 'matrix'

map = File.read('input').each_line.map(&:strip).map(&:chars)
2.times {
  map.size.times.reverse_each { |i|
    map.insert(i, map[i].dup) if map[i].all?('.')
  }
  map = map.transpose
}
map = Matrix[*map]

galaxies = map.each_with_index.select { |c, _, _| c == '#' }.map { |_, i, j| Vector[i, j] }
p galaxies.combination(2).map { |a, b| a - b }.map { |v| v[0].abs + v[1].abs }.sum
