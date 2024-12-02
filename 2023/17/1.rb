require 'matrix'

RIGHT = Vector[ 0,  1]
LEFT  = Vector[ 0, -1]
UP    = Vector[-1,  0] 
DOWN  = Vector[ 1,  0]
INPUT = Matrix[*File.read('input').each_line.map(&:strip).map(&:chars).map { |l| l.map(&:to_i) }]
ROW_RANGE    = 0...INPUT.row_count
COLUMN_RANGE = 0...INPUT.column_count
START_POSITION = Vector[0, 0]
END_POSITION   = Vector[INPUT.row_count - 1, INPUT.column_count - 1]

def insert_queue(queue, position, direction, distance)
  queue.insert(queue.bsearch_index { |_, _, d| d >= distance } || queue.size, [position, direction, distance])
end

def find_shortest(min, max)
  distance_map = Matrix.build(INPUT.row_count, INPUT.column_count) { |i, j| Hash.new { |h, k| h[k] = Float::INFINITY } }
  queue = [[START_POSITION, RIGHT, 0], [START_POSITION, DOWN, 0]]

  while (!queue.empty?)
    position, direction, distance = queue.shift
    ([RIGHT, LEFT, UP, DOWN] - [direction, -direction]).each do |dir|
      pos, d = position, distance
      (1..max).each do |i|
        pos += dir
        if ROW_RANGE.include?(pos[0]) && COLUMN_RANGE.include?(pos[1])
          d += INPUT[*pos]
          if  i >= min && distance_map[*pos][dir] > d
            insert_queue(queue, pos, dir, d)
            distance_map[*pos][dir] = d
          end
        end
      end
    end
  end
  
  distance_map[*END_POSITION].values.min
end

p find_shortest(1, 3)
p find_shortest(4, 10)
