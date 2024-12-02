p File.foreach("input", chomp: true).map(&:bytes).each_slice(3).sum { |b| (b.reduce(&:&).first - 96) % 58 }
