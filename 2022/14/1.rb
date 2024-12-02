require 'set'
require 'matrix'

source = [500, 0]
paths = File.foreach("input").map { |l| l.split(" -> ").map { |s| s.split(",").map(&:to_i) } }
i_min, i_max, j_min, j_max = (paths.flatten(1) + [source]).transpose.map { |x| [x.min, x.max] }.flatten
map = Set[*paths.map { |path|
  path.each_cons(2).map(&:transpose).map { |path|
    path.map(&:sort)
  }.map { |(i1, i2), (j1, j2)| 
    (i1..i2).map { |i| (j1..j2).map { |j| [i, j] } }
  }
}.flatten(3)]

map2 = map.dup

counter = 0
loop do
  sand = source.dup
  pos = loop do
    test = [sand[0], sand[1] + 1]
    if map.include? test
      test[0] -= 1
      if map.include? test
        test[0] += 2
        break sand if map.include? test
      end
    end
    break nil unless (i_min..i_max).include?(test[0]) && (j_min..j_max).include?(test[1])
    sand = test
  end
  break unless pos
  counter += 1
  map.add(pos)
end
Matrix.build(i_max - i_min, j_max) { |i, j| map2.include?([i+i_min, j]) ? "#" : map.include?([i+i_min, j]) ? "o" : " " }.column_vectors.each { |v| puts v.each.map { |e| e}.join }


puts counter
