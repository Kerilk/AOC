p File.open("input").each_line(true).map(&.codepoints).each_slice(3).sum { |b| (b.reduce { |a, v| a & v }.first - 96) % 58 }
