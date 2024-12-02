require 'set'
data, folds = File.read("input").split("\n\n")
data = data.each_line.map { |l| l.split(",").map(&:to_i) }.to_set
folds = folds.each_line.map { |l| l.match(/fold along (\w)=(\d+)/)[1..2] }.map { |direction, index| [direction == "x" ? 0 : 1, index.to_i] }

folds.each { |dir, i|
  data = data.map { |p|
    np = p.dup
    v = np[dir]
    np[dir] = v > i ? i - (v - i) : v
    np
  }.to_set
}

xoffset = 0
yoffset = 0
data.to_a.sort { |(x1, y1), (x2, y2)|
  y1 < y2 ? -1 : y1 > y2 ? 1 : x1 < x2 ? -1 : x1 > x2 ? 1 : 0
}.each { |x, y|
  if y > yoffset
    (y - yoffset).times { puts }
    yoffset = y
    xoffset = 0
  end
  if x > xoffset
    (x - xoffset).times { print " " }
    xoffset = x
  end
  print "#"
  xoffset += 1
}
puts
