require 'set'
require 'matrix'

source = [500, 0]
paths = File.foreach("input").map { |l| l.split(" -> ").map { |s| s.split(",").map(&:to_i) } }
i_min, i_max, j_min, j_max = (paths.flatten(1) + [source]).transpose.map { |x| [x.min, x.max] }.flatten
j_max = j_max + 2
map = Set[*paths.map { |path|
  path.each_cons(2).map(&:transpose).map { |path|
    path.map(&:sort)
  }.map { |(i1, i2), (j1, j2)| 
    (i1..i2).map { |i| (j1..j2).map { |j| [i, j] } }
  }
}.flatten(3)]

counter = 0
loop do
  sand = source.dup
  pos = loop do
    test = [sand[0], sand[1] + 1]
    break sand if  test[1] == j_max
    if map.include? test
      test[0] -= 1
      if map.include? test
        test[0] += 2
        break sand if map.include? test
      end
    end
    sand = test
  end
  counter += 1
  map.add(pos)
  break if pos == source
end
puts counter
