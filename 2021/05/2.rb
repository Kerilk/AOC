require 'pp'
lines = File.read("input").each_line.map { |l| l.match(/(\d+),(\d+) -> (\d+),(\d+)/)[1..-1].map(&:to_i).each_slice(2).to_a }
res = Hash.new { |h, k| h[k] = 0 }
lines.each { |(x1, y1), (x2, y2)|
  dx = x2 - x1
  lx = dx.abs
  dx /= lx if lx > 0
  dy = y2 - y1
  ly = dy.abs
  dy /= ly if ly > 0
  l = [lx, ly].max + 1
  l.times { |i| res[[x1 + i*dx, y1 + i*dy]] += 1 }
}
p res.values.select { |v| v>= 2 }.size
