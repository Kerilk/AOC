boxes = File.read('./input').each_line.collect { |l| l.chomp.split("x").collect(&:to_i) }
puts boxes.sum { |dims|
  c = dims.combination(2).collect { |x, y| x*y }
  area = 2 * c.reduce(:+) + c.min
} 
