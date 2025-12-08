require 'matrix'
boxes = File.read('input').each_line.map { |l| Vector[*l.split(",").map(&:to_i)] }
links = boxes.combination(2).map { |v1, v2| [v1, v2, (v2-v1).norm] }.sort_by(&:last).take(1000)
p links.reduce(Set[*boxes.map { |b| Set[b] }]) { |memo, (b1, b2, _)|
  c1 = memo.find { |c| c.include?(b1) }
  c2 = memo.find { |c| c.include?(b2) }
  c = c1 | c2
  (memo - Set[c1, c2]) << c
}.map(&:size).sort.last(3).reduce(:*)
