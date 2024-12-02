d = [0] + File.read('./input').each_line.collect(&:to_i).sort
d << d.last + 3
diff = d.each_cons(2).collect { |a, b| b - a }
t = diff.tally
puts t[1] * t[3]

comb = Hash.new { |h, k| h[k] = h[k-1] + h[k-2] + h[k-3] }
comb[-2] = 0
comb[-1] = 0
comb[ 0] = 1
puts diff.join.split("3").collect(&:length).collect { |c| comb[c] }.reduce(:*)
