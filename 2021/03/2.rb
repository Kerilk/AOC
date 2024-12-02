i = File.read("input").each_line.map(&:strip).map(&:chars)
block = lambda { |list, op|
  list[0].size.times { |i|
    ones = list.count { |v| v[i] == "1" }
    bit = ones.send(op, list.size - ones) ? "1" : "0"
    list = list.select { |num| num[i] == bit }
    break if list.size == 1
  }
  list.first.join.to_i(2)
}
p block[i, :>=] * block[i, :<]
