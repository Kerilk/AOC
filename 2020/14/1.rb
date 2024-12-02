instrs = File.read('input').each_line.collect { |l|
  case l
  when /mask = ([10X]{36})/
    [:mask, $1.tr("10X","001").to_i(2), $1.tr("10X","100").to_i(2)]
  when /mem\[(\d+)\] = (\d+)/
    [:mem, $1.to_i, $2.to_i]
  end
}

mask = force = 0
mem = {}
instrs.each { |i|
  case i[0]
  when :mask
    mask, force = i[1..2]
  when :mem
    mem[i[1]] = (i[2] & mask) | force
  end
}

puts mem.values.reduce(:+)
