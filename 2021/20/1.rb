def display(input)
  (0...input.shape[1]).each { |j|
    puts (0...input.shape[0]).map { |i|
      input[i, j] == 1 ? "#" : "."
    }.join
  }
end

require 'narray'

arr, data = File.read("input").split("\n\n")
arr = arr.chars.map { |c| c == "#" ? 1 : 0 }
data = data.split("\n").map(&:chars).map { |l| l.map { |c| c == "#" ? 1 : 0 } }
data = NArray.to_na(data.flatten.pack("C*"), NArray::BYTE, data.first.size, data.size)
grid = NArray.byte(data.shape[0] + 4, data.shape[1] + 4)
grid[2..-3,2..-3] = data

$patterns = 512.times.map { |i|
  a = i.digits(2).reverse
  [NArray.to_na(([0]*(9-a.size) + a).pack("C*"), NArray::BYTE, 3, 3), arr[i]]
}.to_h
$grid_state = 0
raise "Unsupported algorithm" unless (arr[0] == 0 && arr[-1] == 1) || (arr[0] == 1 && arr[-1] == 0)
swap = arr[0] == 1

def cycle(input, swap)
  $grid_state ^= 1 if swap
  output = NArray.byte(input.shape[0] + 2, input.shape[1] + 2).fill!($grid_state)
  (1...(input.shape[1]-1)).each { |j|
    (1...(input.shape[0]-1)).each { |i|
      output[i+1, j+1] = $patterns[input[(i-1)..(i+1), (j-1)..(j+1)]]
    }
  }
  output
end

2.times { grid = cycle(grid, swap) }
puts grid.to_a.flatten.tally[1]
48.times { grid = cycle(grid, swap) }
puts grid.to_a.flatten.tally[1]
