require 'matrix'
UP, DOWN, LEFT, RIGHT = Vector[0, -1], Vector[0, 1], Vector[-1, 0], Vector[1, 0]
DIRECTIONS = [UP, UP + RIGHT, RIGHT, DOWN + RIGHT, DOWN, DOWN + LEFT, LEFT, UP + LEFT]
data = File.read('input').each_line.map(&:strip).map(&:chars)
field = Matrix.build(data.size + 2, data.first.size + 2) { |_, _| '.' }
field[1..-2, 1..-2] = Matrix[*data]
p field.each_with_index.count { |e, row, col|
  pos = Vector[row, col]
  e == '@' && DIRECTIONS.count { |d| field[*(pos + d)] == '@' } < 4
}

