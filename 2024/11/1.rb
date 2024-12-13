stones = File.read('input').split.map(&:to_i)
p 25.times.reduce(stones) { |old_stones, _|
  old_stones.reduce([]) { |new_stones, stone|
    new_stones << (stone == 0 ?
      1 : stone.digits.size % 2 == 0 ?
        stone.digits.reverse.each_slice(stone.digits.size/2).map(&:join).map(&:to_i) : stone * 2024)
  }.flatten
}.size
