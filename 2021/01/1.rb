p File.read('input').each_line.collect(&:to_i).each_cons(2).select { |a, b| b > a }.size
