data = File.read('input').split("\n\n")
rules = data[0].each_line.collect { |l|
  l.match(/\A(.*?): (\d+)-(\d+) or (\d+)-(\d+)/)
}.collect{ |m| [m[1]] + m[2..5].collect(&:to_i) }.collect { |n, i1, i2, i3, i4|
  [n, [i1..i2, i3..i4] ]
}.to_h

my_ticket = data[1].lines[1].split(",").collect(&:to_i)

other_tickets = data[2].each_line.drop(1).collect { |l| l.split(",").collect(&:to_i) }

puts other_tickets.flatten.select { |v|
  !rules.values.collect { |i1, i2|
    i1.include?(v) || i2.include?(v)
  }.reduce(:|)
}.reduce(:+)
