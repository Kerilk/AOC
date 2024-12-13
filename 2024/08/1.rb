require 'matrix'

map = File.read('input').each_line.map { |l| l.chomp.chars }
HEIGHT, WIDTH = 0...map.size, 0...map.first.size
antennas = Hash.new { |h,k| h[k] = [] }
map.each_with_index { |l, i|
  l.each_with_index { |c, j|
     antennas[c].push Vector[i, j] if c != '.'
  }
}
antinodes = Set.new
def in_map?(x, y) HEIGHT.include?(x) && WIDTH.include?(y) end
antennas.each { |_, locs|
  locs.combination(2).each { |a, b|
    δ = b - a
    c = b + δ
    d = a - δ
    antinodes.add(c) if in_map? *c
    antinodes.add(d) if in_map? *d
  }
}
p antinodes.size   
