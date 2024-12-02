p File.open("input").each_char.each_cons(4).each_with_index.find { |w, i| w.uniq.size == 4 }.yield_self { |_, i| i + 4 }
