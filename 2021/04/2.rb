require 'set'
prob = File.read("input").split("\n\n")
numbers = prob.first.split(",").collect(&:to_i)
boards = prob[1..-1].map { |b|
  { counts: {lines: [0]*5, columns: [0]*5},
    numbers:  b.split("\n").each_with_index.map { |l, j|
      l.split.each_with_index.map { |v, k|
        [v.to_i, [j, k]]
      } }.flatten(1).to_h
  } }
wins = Set.new
numbers.each { |n|
  boards.each_with_index { |b, i|
    if b[:numbers][n]
      j, k = b[:numbers].delete(n)
      b[:counts][:lines][j] += 1
      b[:counts][:columns][k] += 1
      if b[:counts][:lines][j] == 5 || b[:counts][:lines][j] == 5
        wins.add i
        if wins.size == boards.size
          p b[:numbers].keys.sum * n
          exit
        end
      end
    end
  }
}
