prob = File.read("input").split("\n\n")
p numbers = prob.first.split(",").collect(&:to_i)
p boards = prob[1..-1].map { |b| b.split("\n").collect { |l| l.split.collect(&:to_i) } }
p counts = boards.size.times.collect { {lines: [0]*5, columns: [0]*5} }
numbers.each { |n|
  p "----"
  p n
  boards.each_with_index { |b, i|
    j, k = catch (:found) do
      5.times { |l|
        5.times { |c|
          if n == b[l][c]
            b[l][c] = 0
            throw(:found, [l, c])
          end
        }
      }
      nil
    end
    if j
      p "___"
      p i
      p j
      p k
      counts[i][:lines][j] += 1
      counts[i][:columns][k] += 1
      if counts[i][:lines][j] == 5 || counts[i][:columns][k] == 5
        p b
        p b.flatten.sum
        p n
        p b.flatten.sum * n
        exit
      end
      p counts
    end
  }
}
