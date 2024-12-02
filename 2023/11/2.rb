require 'matrix'
map = Matrix[*File.read('input').each_line.map(&:strip).map(&:chars)]
rows, columns = [map.row_vectors, map.column_vectors].map { |l| l.each_with_index.filter_map { |v, i| i if v.all?('.') } }
galaxies = map.each_with_index.select { |c, _, _| c == '#' }.map { |_, i, j| Vector[i, j] }

distances = lambda { |gap|
  galaxies.combination(2).map { |a, b|
    [[a[0], b[0]].sort, [a[1], b[1]].sort].map { |x, y| x...y }
  }.map { |ranges|
    rows.count { |r| rr.include?(r) } * (gap - 1) + rr.size +
    columns.count { |r| rc.include?(r) } * (gap - 1) + rc.size
  }
}

p distances[2].sum
p distances[1000000].sum
