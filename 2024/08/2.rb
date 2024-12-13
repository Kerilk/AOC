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
cast = lambda { |n, r|
  while in_map?(*n)
    antinodes.add(n)
    n += r
  end
}
antennas.each { |_, locs|
  locs.combination(2).each { |a, b|
    δ = b - a
    cast[b,  δ]
    cast[a, -δ]
  }
}
p antinodes.size   
