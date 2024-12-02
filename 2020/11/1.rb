d = File.read('./input').each_line.collect { |l|
  l.chomp.chars.collect { |c| c == 'L' ? false : nil }
}
height = d.length
width = d[0].length
boards = [[], []]
boards.each { |board|
  board[height+1] = board[0] = [nil] * (width + 2)
  d.each_with_index { |l, i|
    board[i+1] = [nil] + l + [nil]
  }
}

count = 0
source = boards[0]
target = boards[1]
neighbors = [-1, 0, 1].product [-1, 0, 1]
neighbors -= [[0,0]]
loop do
  changed = false
  (1..height).each { |y|
    (1..width).each { |x|
      v = source[y][x]
      unless v.nil?
        n = neighbors.count { |dy, dx| source[y+dy][x+dx] }
	if v && n >= 4
          target[y][x] = false
          changed = true
        elsif !v && n == 0
          target[y][x] = true
          changed = true
        else
          target[y][x] = v
        end
      end
    }
  }
  count += 1
  source, target = target, source
  break unless changed
end

puts source.flatten.count { |v| v }
