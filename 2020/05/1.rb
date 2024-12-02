ids = File.read("input").lines.collect { |s|
  s.tr("FLBR", "0011").to_i(2)
}
puts max = ids.max
puts ((ids.min..max).to_a - ids).first

