corresp = { "<" => [-1, 0], ">" => [1, 0], "^" => [0, 1], "v" => [0, -1] }

dirs = File.read('./input').each_char.collect { |c| corresp[c] }
pos1 = [0, 0]
pos2 = [0, 0]
visited = Hash.new { |h, k| h[k] = 0 }
visited[pos1.dup] += 1
new_dirs = dirs.partition.with_index { |_, i| i.even? }
new_dirs[0].each { |x, y|
  pos1[0] += x
  pos1[1] += y
  visited[pos1.dup] += 1
}
new_dirs[1].each { |x, y|
  pos2[0] += x
  pos2[1] += y
  visited[pos2.dup] += 1
}
puts visited.size
