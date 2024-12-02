decks = File.read("input").split("\n\n")
decks.collect! { |d| d.split("\n")[1..-1].collect(&:to_i) }

while (decks.collect(&:size).min > 0)
  c0 = decks[0].shift
  c1 = decks[1].shift
  if c0 > c1
    decks[0] += [c0, c1]
  else
    decks[1] += [c1, c0]
  end
end

decks.sort! { |d0, d1| d0.size <=> d1.size }
puts decks[1].reverse.each_with_index.sum { |c, i|
  c * (i+1)
}
