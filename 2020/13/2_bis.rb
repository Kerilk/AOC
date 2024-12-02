d = File.read('./input').lines
busses = d[1].split(",").each_with_index.reject { |b, i| b == "x" }.collect { |b, i| [b.to_i, i] }

p busses.reduce([0, 1]) { |(start, step), (b, o)|
  loop do
    break if (start + o) % b == 0
    start += step
  end
  [start, step * b]
}.first
