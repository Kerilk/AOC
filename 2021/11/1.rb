require 'narray'
a = NArray.to_na(File.read("input").each_line.map(&:strip).map(&:chars).map { |a| a.map(&:to_i) }.flatten.pack("c*"), NArray::BYTE, 10, 10)
b = NArray.byte(12, 12)
b[1..10, 1..10] = a
step = 0
flashes = 0
loop do
  new_flashes = 0
  step += 1
  b[1..10, 1..10] += 1
  found = true
  while found
    found = false
    (1..10).each { |i|
      (1..10).each { |j|
        if b[i, j] > 9
          (-1..1).each { |k|
            (-1..1).each { |l|
              b[i + k, j + l] += 1 if b[i + k, j + l] != 0
            }
          }
          found = true
          new_flashes += 1
          b[i, j] = 0
        end
      }
    }
  end
  flashes += new_flashes
  p flashes if step == 100
  break if new_flashes == 100
end
p step
