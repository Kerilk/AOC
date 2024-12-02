cards = File.read('input').each_line.map { |l| l.split(':')[1].split('|').map { |ss| ss.scan(/\d+/).map(&:to_i) } }
p cards.map { |winning, numbers| 1 << ((winning & numbers).size - 1) }.sum

memo = {}
get_count = lambda { |index|
  memo[index] ||= 1 + cards[index].reduce(:&).size.times.map { |i| get_count[i + index + 1] }.sum
}
p cards.size.times.map { |i| get_count[i] }.sum

memo = []
p cards.each_with_index.reverse_each.map { |(winning, numbers), index|
  memo[index] = 1 + (winning & numbers).size.times.map { |i| memo[i + index + 1] }.sum
}.sum
