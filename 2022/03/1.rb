p File.foreach("input", chomp: true).sum { |l| (l.bytes.each_slice(l.size/2).reduce(&:&).first - 96) % 58 }
