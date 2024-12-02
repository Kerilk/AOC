require 'matrix'
require 'set'

LAYOUT = Matrix[*File.read('input').each_line.map(&:strip).map(&:chars)]
ROW_RANGE    = 0...LAYOUT.row_count
COLUMN_RANGE = 0...LAYOUT.column_count
RIGHT = Vector[ 0,  1]
LEFT  = Vector[ 0, -1]
UP    = Vector[-1,  0] 
DOWN  = Vector[ 1,  0]

def add_ray(states, arr, pos, dir)
  arr.push [pos, dir] if ROW_RANGE.include?(pos[0]) && COLUMN_RANGE.include?(pos[1]) && states.add?([pos, dir])
end

def compute_energized(position, direction)
  rays = [[position, direction]]
  states = rays.to_set
  while !rays.empty?
    rays = rays.inject([]) do |memo, (pos, dir)|
      case LAYOUT[*pos]
      when '|'
        if dir[1] != 0
          add_ray(states, memo, pos + UP, UP)
          dir = DOWN
        end
      when '-'
        if dir[0] != 0
          add_ray(states, memo, pos + RIGHT, RIGHT)
          dir = LEFT
        end
      when '\\'
        dir = Vector[dir[1], dir[0]]
      when '/'
        dir = Vector[-dir[1], -dir[0]]
      end
      add_ray(states, memo, pos + dir, dir)
      memo
    end
  end
  return states.map { |pos, _| pos }.to_set.size
end

puts compute_energized(Vector[0, 0], Vector[0, 1])

p [
  [[ROW_RANGE.to_a, [0                      ]], Vector[ 0,  1]],
  [[ROW_RANGE.to_a, [LAYOUT.column_count - 1]], Vector[ 0, -1]],
  [[[0                   ], COLUMN_RANGE.to_a], Vector[ 1,  0]],
  [[[LAYOUT.row_count - 1], COLUMN_RANGE.to_a], Vector[-1,  0]],
].map { |(ii, jj), direction|
  ii.product(jj).map { |position|
    compute_energized(Vector[*position], direction)
  }.max
}.max
