d = File.read('./input').lines
timestamp = d[0].to_i
busses = d[1].split(",").reject { |x| x == "x" }.collect(&:to_i)
bus = nil
departure = (timestamp..Float::INFINITY).find { |t|
  bus = busses.find { |b|
    t % b == 0
  }
}
puts (departure - timestamp) * bus
