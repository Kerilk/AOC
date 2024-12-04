input = File.read("input").each_line.map { |l| l.chomp }
search = ["MAS", "MAS".reverse]
p (1...(input.size-1)).each.sum { |i|
  (1...(input[0].size-1)).each.sum { |j|
    (-1..1).each.inject(["", ""]) { |(a, b), k|
      a << input[i+k][j+k]
      b << input[i+k][j-k]
      [a, b]
    }.filter { |x| search.include?(x) }.count / 2
  }
}
