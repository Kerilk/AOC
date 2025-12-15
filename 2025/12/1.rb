require 'matrix'
$shapes, regions = File.read('ref').split("\n\n").then { |*shapes, regions|
  [shapes.map { |s| s.each_line.map(&:chomp)[1..-1].map(&:chars) },
   regions.each_line.map { |l| l.split(": ").then { |size, indices| [size.split('x').map(&:to_i), indices.split(' ').map(&:to_i).tally] } } ]
}

$shapes.map! { |s| Matrix.build(s.size, s.first.size) { |i, j| s[i][j] == '#' ? 1 : 0 } }
regions.map! { |((x, y), indices)| [Matrix.zero(x, y), indices.each_with_index.flat_map { |i, j| [j]*i }] }

$shapes.map! { |s| Set[s, s.transpose] }.map! { |list|
  3.times.reduce([Set[*list.to_a], list]) { |(memo, ss), _|
    new_ss = ss.map { |s| Matrix.columns(s.row_vectors.reverse) }
    [memo | new_ss, new_ss]
  }.first
}

MASK = 3.times.to_a.product(3.times.to_a)
