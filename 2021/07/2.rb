d = File.read("input").split(",").map(&:to_i)
mean = d.sum.to_f/d.size
mean_floor = mean.floor
mean_ceil = mean.ceil
p d.reduce([0, 0]) { |memo, v|
  l_floor = (v-mean_floor).abs
  l_ceil = (v-mean_ceil).abs
  [memo[0] + (l_floor * (l_floor + 1)) / 2, memo[1] +  (l_ceil * (l_ceil + 1)) / 2]
}.min
