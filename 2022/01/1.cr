p File.read("input").split("\n\n").map { |e| e.lines.sum(&.to_i) }.max
