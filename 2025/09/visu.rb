require 'rvg/rvg'
require 'matrix'
tiles = File.read('input').each_line.map { |l| Vector[*l.split(',').map(&:to_i)] }
remapped_tiles = tiles.map { |p| Vector[p[0]/10.0, p[1]/10.0] }
xmax = 10000
ymax = 10000

rvg = Magick::RVG.new(xmax, ymax).viewbox(0, 0, xmax, ymax) do |canvas|
  canvas.background_fill = 'white'
  segments = remapped_tiles.each_cons(2).to_a << [remapped_tiles.last, remapped_tiles.first]
  segments.each { |p1, p2|
    canvas.line(*p1.to_a, *p2.to_a)
  }
end
rvg.draw.write('visu1.gif')

x_map, y_map = tiles.map(&:to_a).transpose.map(&:sort).map(&:uniq).map(&:each_with_index).map(&:to_h)
remapped_tiles = tiles.map { |p| Vector[1 + x_map[p[0]]*2, 1 + y_map[p[1]]*2] }

xmax = 1 + x_map.values.max*2 + 2
ymax = 1 + y_map.values.max*2 + 2
rvg = Magick::RVG.new(xmax, ymax).viewbox(0, 0, xmax, ymax) do |canvas|
  canvas.background_fill = 'white'
  segments = remapped_tiles.each_cons(2).to_a << [remapped_tiles.last, remapped_tiles.first]
  segments.each { |p1, p2|
    canvas.line(*p1.to_a, *p2.to_a)
  }
end
rvg.draw.write('visu2.gif')
