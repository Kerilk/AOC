require 'matrix'
boxes = File.read('input').each_line.map { |l| Vector[*l.split(",").map(&:to_i)] }
links = boxes.combination(2).map { |v1, v2| [v1, v2, (v2-v1).norm] }.sort_by(&:last)
circuits = Set[*boxes.map { |b| Set[b] }]
b1, b2 = nil, nil
while circuits.size != 1
  b1, b2, _ = *links.shift
  c1 = circuits.find { |c| c.include?(b1) }
  c2 = circuits.find { |c| c.include?(b2) }
  c = c1 | c2
  circuits = (circuits - Set[c1, c2]) << c
end
p b1[0] * b2[0]
