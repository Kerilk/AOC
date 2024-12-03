p File.read('input').gsub(/don't\(\).*?(do\(\)|\Z)/m, "\n").scan(/mul\((\d+),(\d+)\)/).map { |m| m.map(&:to_i).reduce(:*) }.sum()
