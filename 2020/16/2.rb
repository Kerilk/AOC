data = File.read('input').split("\n\n")
rules = data[0].each_line.collect { |l|
  [l.scan(/\A(.*?):/).first.first,
   l.scan(/(\d+)-(\d+)/).collect { |i1, i2| Range.new(i1.to_i, i2.to_i) } ]
}.to_h

my_ticket = data[1].lines[1].split(",").collect(&:to_i)
other_tickets = data[2].each_line.drop(1).collect { |l| l.split(",").collect(&:to_i) }

other_tickets.reject! { |t|
  t.find { |v|
    !rules.values.find { |ints|
      ints.collect { |i| i.include?(v) }.reduce(:|)
    }
  }
}
values_arr = other_tickets.transpose

fields = values_arr.collect { |values|
  rules.reject { |n, ints|
    values.find { |v| ints.collect { |i| !i.include?(v) }.reduce(:&) }
  }.keys
}

final_fields = []
while fields.collect(&:size).max > 0
  fields.each_with_index.select { |f, _|
    f.size == 1
  }.each { |f, i|
    n = f.first
    fields.each { |field| field.delete(n) }
    final_fields[i] = n
  }
end

puts final_fields.zip(my_ticket).collect { |n, v|
  n.match("departure") ? v : 1
}.reduce(:*)
