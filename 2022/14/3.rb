require 'set'
require 'matrix'

source = [500, 0]
paths = File.foreach("input").map { |l| l.split(" -> ").map { |s| s.split(",").map(&:to_i) } }
i_min, i_max, j_min, j_max = (paths.flatten(1) + [source]).transpose.map { |x| [x.min, x.max] }.flatten
p j_max = j_max + 2
i_min = [i_min, 500 - j_max].min
map = Matrix.build(500 - i_min + j_max, j_max) { false }
paths.each { |path|
  path.each_cons(2).map(&:transpose).map { |path|
    path.map(&:sort)
  }.each { |(i1, i2), (j1, j2)| 
    (i1..i2).each { |i| (j1..j2).map { |j| map[i - i_min, j] = "#" } }
  }
}

is, js = 500 - i_min, 0
counter = 0
loop do
  i, j = is, js
  i, j = loop do
    it, jt = i, j + 1
    break i, j if jt == j_max
    if map[it, jt]
      it -= 1
      if map[it, jt]
        it += 2
        break i, j if map[it, jt]
      end
    end
    i, j = it, jt
  end
  counter += 1
  map[i, j] = "o"
  break if i == is && j == js
end
puts map.column_vectors.map { |v| v.each.map { |e| e ? e : " " }.join }
puts counter
