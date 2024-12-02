boxes = File.read('./input').each_line.collect { |l| l.chomp.split("x").collect(&:to_i) }
puts boxes.sum { |dims|
  dims.min(2).reduce(:+)*2 + dims.reduce(:*)
} 
