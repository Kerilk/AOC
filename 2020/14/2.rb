instrs = File.read('input').each_line.collect { |l|
  case l
  when /mask = ([10X]{36})/
    [:mask, $1.tr("10X","010").to_i(2), $1.tr("10X","100").to_i(2),
     $1.chars.reverse.each_with_index.select { |c, i| c == "X" }.collect { |_, i| 1 << i }]
  when /mem\[(\d+)\] = (\d+)/
    [:mem, $1.to_i, $2.to_i]
  end
}

mask = force = floating = nil
mem = {}
instrs.each { |i|
  case i[0]
  when :mask
    mask, force, flt = i[1..3]
    floating = (0...(2 ** flt.length)).collect { |j|
      j.digits(2).each_with_index.map { |v, k| v == 0 ? 0 : flt[k] }.reduce(:|)
    }
  when :mem
    base = (i[1] & mask) | force
    floating.each { |f|
      mem[f | base] = i[2]
    }
  end
}
puts mem.values.reduce(:+)
