stones = File.read('input').split.map(&:to_i)
$memo = {}
def gen_stones(blinks, stone)
  $memo[[stone, blinks]] ||= begin
      if blinks == 0
        1
      elsif stone == 0
        gen_stones(blinks-1, 1)
      elsif stone.digits.size % 2 == 0
        stone = stone.to_s
        gen_stones(blinks-1, stone[...stone.size/2].to_i) +
        gen_stones(blinks-1, stone[stone.size/2..].to_i)
      else
        gen_stones(blinks-1, stone * 2024)
      end
    end
end
p stones.sum { |s| gen_stones(75, s) }
