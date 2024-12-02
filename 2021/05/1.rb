lines = File.read("input").each_line.map { |l| l.match(/(\d+),(\d+) -> (\d+),(\d+)/)[1..-1].map(&:to_i).each_slice(2).to_a }
res = Hash.new { |h, k| h[k] = 0 }
lines.select { |(x1, y1), (x2, y2)| x1 == x2 || y1 == y2 }.each { |(x1, y1), (x2, y2)|
  x1, x2 = x2, x1 if x2 < x1
  y1, y2 = y2, y1 if y2 < y1
  (x1..x2).each { |x|
    (y1..y2).each { |y|
      res[[x, y]] += 1
    }
  }
}
p res.values.select { |v| v>= 2 }.size
