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
map = Matrix[*grid.row_count.times.map { ['.']*grid.column_count }]

position = Vector[*grid.find_index('S')]
map[*position] = 0
direction = [NORTH, EAST, SOUTH, WEST].find { |d|
  t = tubes[grid[*(position + d)]]
  t.find { |d2| d == -1 * d2 } if t
}
while direction
  new_pos = position + direction
  direction = if map[*new_pos] == '.'
    map[*new_pos] = map[*position] + 1
    position = new_pos
    tubes[grid[*new_pos]].find { |d| direction != -1 * d }
  end
end
p (0.5*map[*position]).ceil
