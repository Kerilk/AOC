a, b = File.read('input').each_line.map { |l| l.split.map(&:to_i) }.transpose
b = b.tally
p a.sum { |v| v * (b[v] || 0) }
