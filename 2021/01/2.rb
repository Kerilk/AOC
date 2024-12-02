p File.read('input').each_line.map(&:to_i).each_cons(3).map(&:sum).each_cons(2).select { |a, b| b > a }.size
