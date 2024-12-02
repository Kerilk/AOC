puts File.read('input').each_char.sum { |c| c == "(" ? 1 : -1 }
