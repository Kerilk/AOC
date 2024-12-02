require 'narray'
d = File.read("input").each_line.map(&:strip).map(&:chars)
nd = NArray.to_na(d.flatten.map(&:to_i).pack("c*"), NArray::BYTE, d.first.size, d.size)

a = NArray.byte(d.first.size + 2, d.size + 2)
a[0..-1, 0..-1] = 10
a[1..-2, 1..-2] = nd

b = NArray.sint(d.first.size + 2, d.size + 2)

found = 0
(1..d.size).map { |i|
  (1..d.first.size).map { |j|
    v = a[j, i]
    if v < a[j - 1, i] && v < a[j + 1, i] && v < a[j, i - 1] && v < a[j, i + 1]
      found += 1
      b[j, i] = found
    end
  }
}
tagged = 0
newly_tagged = found

l = lambda { |i, j, v| v > a[j, i] && b[j, i] != 0 ? b[j, i] : 0 }
while tagged != newly_tagged do
  tagged = newly_tagged
  (1..d.size).map { |i|
    (1..d.first.size).map { |j|
      v = a[j, i]
      t = b[j, i]
      if t == 0 && v < 9
        tags = []
        tags.push l[i, j-1, v]
        tags.push l[i, j+1, v]
        tags.push l[i-1, j, v]
        tags.push l[i+1, j, v]
        raise "error: #{tags}" if tags.uniq.size > 2
        t = tags.max
        newly_tagged += 1 if t > 0
        b[j, i] = t
      end
    }
  }
end
p b.to_a.flatten.tally.reject { |k, _| k == 0 }.values.sort.last(3).reduce(:*)
