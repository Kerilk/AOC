v = [0]*9
File.read("input").split(",").map(&:to_i).tally.each { |k, s| v[k] = s }
def step(c, v)
  c.times {
    v.rotate!(1)
    v[6] += v[8]
  }
  v
end
p step(80, v).sum
p step(256-80, v).sum
