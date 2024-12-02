p File.foreach("input").map { |l| l.split(/-|,/).map(&:to_i) }.count { |a, b, c, d| a <= d && c <= b }
