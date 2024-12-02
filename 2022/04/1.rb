p File.foreach("input").map { |l| eval("[#{l.gsub("-", "..")}]") }.count { |r1, r2| r1.cover?(r2) || r2.cover?(r1) }
