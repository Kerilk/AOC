p File.read("input").each_line.map { |l| l.chars.filter { |c| c.match(/\d/) } }.map { |a| a.first + a.last }.sum(&:to_i)
