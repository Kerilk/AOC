p File.open("input").each_line(true).sum { |l| (l.codepoints.each_slice(l.size//2).reduce { |a, v| a & v }.first - 96) % 58 }
