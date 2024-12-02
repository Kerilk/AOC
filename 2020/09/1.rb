data = File.read("input").each_line.collect { |l| l.to_i }

_, res = data.each_cons(25).lazy.zip(data.drop(25)).find { |wind, val|
  !wind.combination(2).collect { |c| c.reduce(:+) }.include?(val)
}
puts res

b = nil
a = (0...(data.length-1)).find { |i|
  sum = data[i]
  b = (i+1..(data.length-1)).find { |j| (sum += data[j]) >= res }
  sum == res
}
puts data[a..b].min + data[a..b].max
