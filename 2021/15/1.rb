require 'narray'
require 'colorize'
d = File.read("input").each_line.map(&:strip).map(&:chars)
input = NArray.to_na(d.flatten.map(&:to_i).pack("L*"), NArray::INT, d.first.size, d.size)
output = NArray.int(d.first.size, d.size)

n = input.shape[0]
m = input.shape[1]
(input.shape.sum - 1).times do |l|
  i0 = [0, l - m + 1].max
  j0 = [l, n - 1].min
  c = [l + 1, m - i0, ].min
  c.times do |k|
    i = i0 + k
    j = j0 - k
    v = []
    v.push output[i - 1, j] if i > 0
    v.push output[i, j - 1] if j > 0
    output[i, j] = input[i, j] + v.min unless v.empty?
  end
end

path = NArray.byte(n, m)
path[-1, -1] = 1
(input.shape.sum - 2).downto(1) do |l|
  i0 = [0, l - m + 1].max
  j0 = [l, n - 1].min
  c = [l + 1, m - i0, ].min
  c.times do |k|
    i = i0 + k
    j = j0 - k
    if path[i, j] == 1
      v = []
      v.push output[i - 1, j] if i > 0
      v.push output[i, j - 1] if j > 0
      v = v.min
      path[i - 1, j] = 1 if i > 0 && output[i - 1, j] == v
      path[i, j - 1] = 1 if j > 0 && output[i, j - 1] == v
    end
  end
end
puts path.to_a.map(&:join).join("\n")
pr = input.to_a
m.times { |j|
  n.times { |i|
    pr[j][i] = input[i, j].to_s
    pr[j][i] = pr[j][i].blue if path[i, j] == 1
  }
}
puts pr.map(&:join).join("\n")

p output[-1, -1]
