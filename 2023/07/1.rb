labels = %w(2 3 4 5 6 7 8 9 T J Q K A).each_with_index.to_h
hands = File.read('input').each_line.map { |l| l.split(' ') }.map { |hand, bid| [hand.chars, bid.to_i] }
p hands.map { |hand, bid|
  [ hand.tally.values.sort.reverse,
    hand.map { |c| labels[c] },
    bid ]
}.sort.each.with_index(1).map { |(_, _, bid), i| bid * i }.sum

labels["J"] = -1
p hands.map { |hand, bid|
  [ hand.tally.then { |h| [h.delete("J") || 0, h.values.sort.reverse] }.then { |v, vals| vals[0] = v + (vals[0] || 0); vals },
    hand.map { |c| labels[c] },
    bid ]
}.sort.each.with_index(1).map { |(_, _, bid), i| bid * i }.sum
