d = File.read('./input').lines
busses = d[1].split(",").each_with_index.reject { |b, i| b == "x" }.map { |b, i| [b.to_i, i] }

step = 1
start = 0
busses.each { |b, o|
  loop do
    break if (start + o) % b == 0
    start += step
  end
  step *= b
}
puts start
