input = File.read('input')

numbers = input.each_line.map { |l|
  l.to_enum(:scan, /\d+/).map { Regexp.last_match }.map { |m| [m[0].to_i, (m.begin(0)-1)..m.end(0)] }
}
symbols = input.each_line.map { |l|
  l.to_enum(:scan, /[^.0123456789\n]/).map { Regexp.last_match }.map { |m| [m[0], m.begin(0)] }
}

halo = lambda { |index| [index - 1, 0].max..[index + 1, numbers.size - 1].min }

p numbers.each_with_index.map { |nums, i|
  nums.select { |_, range|
    halo[i].any? { |ii|
      symbols[ii].any? { |_, j| range.include?(j) }
    }
  }.map(&:first).sum
}.sum

p symbols.each_with_index.map { |syms, i|
  syms.select { |s, _| s == '*' }.map { |_, j|
    halo[i].map { |ii|
      numbers[ii].filter_map { |num, range| num if range.include?(j) }
    }.flatten
  }.select { |nums| nums.size == 2 }.map { |a, b| a * b }.sum
}.sum
