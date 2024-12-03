p File.read('input').gsub(/don't\(\).*?do\(\)/m, "\n").gsub(/don't\(\).*/m, ';').scan(/mul\((\d+),(\d+)\)/).map { |m| m.map(&:to_i).reduce(:*) }.sum()
