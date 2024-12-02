puts File.read('input').each_char.collect { |c| c == "(" ? 1 : -1 }.inject([0]) { |x, y| x + [x.last + y] }.each_with_index.find { |x, i| x < 0 }
