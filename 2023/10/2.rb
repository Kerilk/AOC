require 'matrix'

SOUTH = Vector[ 1,  0]
NORTH = Vector[-1,  0]
EAST  = Vector[ 0,  1]
WEST  = Vector[ 0, -1]

tubes = {
  '|' => [NORTH, SOUTH],
  '-' => [EAST,  WEST],
  'L' => [NORTH, EAST],
  'J' => [NORTH, WEST],
  '7' => [SOUTH, WEST],
  'F' => [SOUTH, EAST],
}

grid = *File.read('input').each_line.map(&:strip).map(&:chars).each { |l| l.push('.').unshift('.') }
grid = Matrix[*grid.push(['.']*grid[0].size).unshift(['.']*grid[0].size)]
map = Matrix.zero(grid.row_count, grid.column_count)

position = Vector[*grid.find_index('S')]
incoming, direction = [NORTH, EAST, SOUTH, WEST].find_all { |d|
  t = tubes[grid[*(position + d)]]
  t.find { |d2| d == -1 * d2 } if t
}
map[*position] = (direction - incoming).to_a
while !map[*(position += direction)].kind_of?(Array)
  new_dir = tubes[grid[*position]].find { |d| direction != -1 * d }
  map[*position] = (new_dir + direction).to_a
  direction = new_dir
end

puts map.each.select { |c| c.kind_of?(Array) }.count/2

map.row_vectors.each_with_index.each { |v, i|
  sum = Vector[0, 0]
  v.each_with_index { |c, j|
    if c.kind_of?(Array)
      sum += Vector[*c]
    else
      map[i,j] = (sum[0].abs == 2 ? 'I' : 'O')
    end
  }
}

puts map.each.select { |c| c == 'I' }.count

#puts map.row_vectors.map { |v| v.to_a.map(&:inspect).join(',') }.join("\n")
