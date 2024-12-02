p File.foreach("input").map(&:bytes).map { |o, _, s| [o - 66, s - 88] }.sum { |i, j| (j + i) % 3 + 1 + 3 * j }
