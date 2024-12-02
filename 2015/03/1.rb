corresp = { "<" => [-1, 0], ">" => [1, 0], "^" => [0, 1], "v" => [0, -1] }

dirs = File.read('./input').each_char.collect { |c| corresp[c] }
pos = [0, 0]
visited = Hash.new { |h, k| h[k] = 0 }
visited[pos.dup] += 1
dirs.each { |x, y|
  pos[0] += x
  pos[1] += y
  visited[pos.dup] += 1
}
puts visited.size
