d = [0] + File.read('./input').each_line.collect(&:to_i).sort
d << d.last + 3
diff = d.each_cons(2).collect { |a, b| b - a }
t = diff.tally
puts t[1] * t[3]

counts = [0] * (d.last+2)
counts[0] = 1
d.drop(1).each { |v|
   counts[v] = counts[v-3] + counts[v-2] + counts[v-1]
}
puts counts[d.last]
