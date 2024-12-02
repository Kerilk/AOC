require 'set'
data, folds = File.read("input").split("\n\n")
data = data.each_line.map { |l| l.split(",").map(&:to_i) }.to_set
folds = folds.each_line.map { |l| l.match(/fold along (\w)=(\d+)/)[1..2] }.map { |direction, index| [direction == "x" ? 0 : 1, index.to_i] }

def fold(d, dir, i)
  d.map { |p|
    np = p.dup
    v = np[dir]
    np[dir] = v > i ? i - (v - i) : v
    np
  }.to_set
end

folds[0..0].each { |dir, i|
  data = fold(data, dir, i)
  p data.size
}
