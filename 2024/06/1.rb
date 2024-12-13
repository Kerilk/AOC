require 'matrix'

START_DIRECTION = Vector[-1, 0]
TURN = Matrix[
  [0, 1],
  [-1, 0]]
MAP = Matrix[*File.read('input').each_line.with_index.map { |l, i|
  l.chomp.chars.each_with_index.map { |e, j|
    case e when "."
      0
    when "#"
      1
    when "^"
      START_POSITION = Vector[i, j]
      0
    end
  }
}]
ROW_COUNT = MAP.row_count
COLUMN_COUNT = MAP.column_count

def inside_map?(x, y)
   (0...ROW_COUNT).include?(x) && (0...COLUMN_COUNT).include?(y)
end

def simulate(path = false)
  positions = Set.new
  position = START_POSITION
  direction = START_DIRECTION
  cycle = while inside_map?(*position)
    break true unless positions.add?([*position, *direction])
    new_position = position + direction
    while inside_map?(*new_position) && MAP[*new_position] == 1
      direction = TURN * direction
      new_position = position + direction
    end
    position = new_position
  end
  cycle ? nil : path ? positions.map { |k| k[0..1] }.to_set : true
end

p simulate(true)
