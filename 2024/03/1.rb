p File.read('input').scan(/mul\((\d+),(\d+)\)/).map { |m| m.map(&:to_i).reduce(:*) }.sum()
