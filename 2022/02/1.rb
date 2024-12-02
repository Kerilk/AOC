p File.foreach("input").map(&:bytes).map { |o, _, s| [o - 65, s - 87] }.sum { |i, j| 3 * (j - i) % 9 + j }
