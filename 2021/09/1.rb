require 'narray'
d = File.read("input").each_line.map(&:strip).map(&:chars)
nd = NArray.to_na(d.flatten.map(&:to_i).pack("c*"), NArray::BYTE, d.first.size, d.size)

a = NArray.byte(d.first.size + 2, d.size + 2)
a[0..-1, 0..-1] = 10
a[1..-2, 1..-2] = nd

p (1..d.size).map { |i|
  (1..d.first.size).map { |j|
    v = a[j, i]
    v < a[j - 1, i] && v < a[j + 1, i] && v < a[j, i - 1] && v < a[j, i + 1] ? v + 1 : 0
  }.sum
}.sum

