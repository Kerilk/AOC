p File.read("input").split("\n\n").collect { |e| e.lines.sum(&:to_i) }.sort[-3..-1].sum
