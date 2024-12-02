require 'set'
decks = File.read("input").split("\n\n").collect { |d|
  d.split("\n")[1..-1].collect(&:to_i)
}

def play_game(decks)
  history = Set.new
  while (decks.collect(&:size).min > 0)
    snap = [decks[0].dup, decks[1].dup]
    return decks[0], 0 if !history.add? snap
    c0 = decks[0].shift
    c1 = decks[1].shift
    winner = if decks[0].size >= c0 && decks[1].size >= c1
        play_game([decks[0].first(c0), decks[1].first(c1)])[1]
      else
        c0 > c1 ? 0 : 1
      end
    decks[winner] += (winner == 0 ? [c0, c1] : [c1, c0])
  end
  decks.each_with_index.select { |d, _| d.size > 0 }.first
end

deck, _ = play_game(decks)
puts deck.reverse.each_with_index.sum { |c, i| c * (i+1) }
