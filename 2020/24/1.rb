require 'narray'
$map = {
  "e"  => [ 1,  0],
  "w"  => [-1,  0],
  "se" => [ 1, -1],
  "sw" => [ 0, -1],
  "ne" => [ 0,  1],
  "nw" => [-1,  1]
}

def cycle(source, target)
  stencil = $map.values
  shape = source.shape
  (1...(shape[1]-1)).each { |y|
    (1...(shape[0]-1)).each { |x|
      neigh = stencil.sum { |vec| source[x + vec[0], y + vec[1]] }
      target[x, y] = if source[x, y] == 1
          (neigh == 0 || neigh > 2) ? 0 : 1
        else
          neigh == 2 ? 1 : 0
        end
    }
  }
end

data = File.read('input').each_line.collect {|l| l.chomp.scan(/e|se|sw|w|ne|nw/).collect { |d| $map[d] } }

tiles = data.collect { |dirs| dirs.reduce([0, 0]) { |m, e| m[0] += e[0]; m[1] += e[1]; m } }.tally
p tiles.count { |_, v| v % 2 == 1}
black_tiles = tiles.select { |_, v| v % 2 == 1 }.keys

cycles = 100
halo = cycles + 1
xs = black_tiles.collect { |p| p[0] }
ys = black_tiles.collect { |p| p[1] }
corners = [ [xs.min, ys.min], [xs.max, xs.max]]
width = corners[1][0] - corners[0][0] + 1 + 2 * halo
height = corners[1][1] - corners[0][1] + 1 + 2 * halo

center = [halo - corners[0][0], halo - corners[0][1]]

source = NArray.int(width, height)
target = NArray.int(width, height)

black_tiles.each { |p|
  source[p[0] + center[0], p[1] + center[1]] = 1
}

cycles.times {
  cycle(source, target)
  source, target = target, source
}
puts source.sum
