require 'matrix'
require 'set'

DIRECTIONS = [
  U = Vector[-1,  0],
  D = Vector[ 1,  0],
  L = Vector[ 0, -1],
  R = Vector[ 0,  1],
]
BOARD = Matrix[*File.read('input').each_line.map(&:strip).map(&:chars).each_with_index.map { |l, i|
  l.each_with_index.map { |c, j|
    case c
    when '#'
      c
    when 'S', '.'
      START = Vector[i, j] if c == 'S'
      '.'
    end
  }
}]
ROW_COUNT = BOARD.row_count
ROW_RANGE = 0...ROW_COUNT
COLUMN_RANGE = 0...ROW_COUNT
BOARD.row_vectors.map(&:to_a).map(&:join).join("\n")

def compute_cycle(count, start)
  positions = [start].to_set
  count.times { |i|
    positions = positions.reduce(Set.new) { |memo, p|
      DIRECTIONS.each { |dir|
        np = p + dir
        memo.add np if BOARD[np[0] % ROW_COUNT, np[1] % ROW_COUNT] == '.'
      }
      memo
    }
  }
  positions
end
p compute_cycle(64, START).size

div, remainder = 26501365.divmod(ROW_COUNT)
positions = compute_cycle(2*ROW_COUNT + remainder, START)

get_range = lambda { |n| (n * ROW_COUNT)...((n+1)* ROW_COUNT) }
get_count = lambda { |ni, nj| positions.filter { |p| get_range[ni].include?(p[0]) && get_range[nj].include?(p[1]) }.count }

p (div - 1) * (div - 1) * get_count[0, 0] +
  (div - 1) * (get_count[1, 1] + get_count[-1, 1] + get_count[-1, -1] + get_count[1, -1]) +
  div * div * get_count[1, 0] +
  div * (get_count[2, 1] + get_count[-2, 1] + get_count[2, -1] + get_count[-2, -1]) +
  get_count[2, 0] + get_count[-2, 0] + get_count[0, 2] + get_count[0, -2]

