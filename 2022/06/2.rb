p File.open("input").each_char.each_cons(14).with_index(14).find { |w, _| w.uniq.size == 14 }.last
