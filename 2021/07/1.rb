d = File.read("input").split(",").map(&:to_i)
median = d.sort[d.size/2]
p d.reduce(0) { |memo, v| memo + (v-median).abs }
