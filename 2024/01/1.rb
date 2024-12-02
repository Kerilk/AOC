a, b = File.read('input').each_line.map { |l| l.split.map(&:to_i) }.transpose
p [a, b].map(&:sort).transpose.map { |a, b| (a - b).abs }.sum
