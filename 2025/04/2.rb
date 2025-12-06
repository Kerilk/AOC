require 'matrix'
UP, DOWN, LEFT, RIGHT = Vector[0, -1], Vector[0, 1], Vector[-1, 0], Vector[1, 0]
DIRECTIONS = [UP, UP + RIGHT, RIGHT, DOWN + RIGHT, DOWN, DOWN + LEFT, LEFT, UP + LEFT]
data = File.read('input').each_line.map(&:strip).map(&:chars)
field = Matrix.build(data.size + 2, data.first.size + 2) { |_, _| '.' }
dest = field.dup
field[1..-2, 1..-2] = Matrix[*data]
init_count = count = field.each.count('@')
last_count = 0
while last_count != count
  field.each_with_index { |e, row, col|
    pos = Vector[row, col]
    if e == '@' && DIRECTIONS.count { |d| field[*(pos + d)] == '@' } < 4
      dest[row, col] = '.'
    else
      dest[row, col] = e
    end
  }
  field, dest = dest, field
  last_count, count = count, field.each.count('@')
end
p init_count - count
