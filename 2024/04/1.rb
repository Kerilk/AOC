input = File.read("input").each_line.map { |l| l.chomp + ' ' * 3 }
n_rows = input.size
n_cols = input[0].size - 3
input += [' '*input[0].size] * 3
search = ["XMAS", "XMAS".reverse]
p (n_rows).times.sum { |i|
  (n_cols).times.sum { |j|
    4.times.inject(["", "", "", ""]) { |(a, b, c, d), k|
      [ a << input[i+k][j  ],
        b << input[i  ][j+k],
        c << input[i+k][j+k],
        d << input[i+k][-1-k-j] ]
    }.filter { |x| search.include?(x) }.count
  }
}
