require 'matrix'
UP    = Vector[-1,  0]
DOWN  = Vector[ 1,  0]
LEFT  = Vector[ 0, -1]
RIGHT = Vector[ 0,  1]
DIRECTIONS = [UP, DOWN, LEFT, RIGHT]
steps = Hash.new { |h, k| h[k] = Hash.new { |h2, k2| h2[k2] = 0 } }
m = Matrix[*File.read('input').each_line.with_index.map { |l, i|
  l.chomp.chars.each_with_index.map { |c, j|
    steps[9][Vector[i, j]] += 1 if c == "9"
    c.to_i
  }
}]
ROWS = 0...m.row_count
COLUMNS = 0...m.column_count
def inside?(i, j) ROWS.include?(i) && COLUMNS.include?(j) end
8.downto(0) { |k|
  steps[k+1].each { |p, count|
    DIRECTIONS.map { |d| p + d }.filter { |c| inside?(*c) && m[*c] == k }.each { |c|
      steps[k][c] += count
    }
  }
}
p steps[0].sum { |_, count| count }
