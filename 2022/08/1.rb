require 'matrix'

forest = Matrix[*File.foreach("input", chomp: true).map { |l| l.chars.map(&:to_i) }]

visible = Matrix.zero(forest.row_count, forest.column_count)
l = lambda { |e, r, c, o| visible[r, c], o[0] = 1, e if e > o[0] }
l1 = lambda { |(e, r), (o, c)| l.call(e, r, c, o) }
l2 = lambda { |(e, c), (o, r)| l.call(e, r, c, o) }
[[forest.column_vectors, l1], [forest.row_vectors, l2]].each { |it, b|
  it.each_with_index { |v, i|
    [v.each_with_index, v.each_with_index.reverse_each].each { |it2|
      it2.each_with_object([[-1], i], &b)
    }
  }
}
p visible.sum

p forest.each_with_index.map { |e, r, c|
  l = lambda { |r2, c2, o|
    if o[0]
      o[0] = forest[r2, c2] < e
      true
    else
      false
    end
  }
  l1 = lambda { |r2, o|
    l.call(r2, c, o)
  }
  l2 = lambda { |c2, o|
    l.call(r, c2, o)
  }
  [[r, l1, forest.row_count], [c, l2, forest.column_count]].map { |v, b, max|
    [(v-1).downto(0), (v+1)...max].map { |it| it.each_with_object([true]).take_while(&b).count }
  }.flatten.reduce(:*)
}.max
