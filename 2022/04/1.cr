p File.open("input").each_line.map { |l| l.split(/,|-/).map(&.to_i) }.count { |(a, b, c, d)| a <= c && d <= b || c <= a && b <= d }
