require 'matrix'
height_map = Matrix[*File.foreach("input", chomp: true).map { |l| l.chars }]
start_position, end_position = ["S", "E"].map { |c|
  height_map.each_with_index.find { |e, _, _| e == c }.yield_self { |_, i, j| [i, j] }
}
height_map[*start_position], height_map[*end_position] = "a", "z"
height_map.map! { |e| e.bytes.first - 97 }
distances = Matrix.build(height_map.row_size, height_map.column_size) { Float::INFINITY }
distances[*end_position] = 0
queue = [[end_position, 0]]

def insert_queue(queue, position, distance)
  # Update priority cannot be done cheaply with a list (O(n))
  queue.insert(queue.bsearch_index { |_, d| d >= distance } || queue.size, [position, distance])
end

directions = [[0, 1], [0, -1], [1, 0], [-1, 0]]

i_range = (0...height_map.row_size)
j_range = (0...height_map.column_size)
while (!queue.empty?)
  i, j, distance = queue.shift.flatten
  # We do not update element priority in queue, so they can reappear 
  next if distance > distances[i, j]
  hlimit = height_map[i, j] - 1
  distance += 1
  directions.each { |di, dj|
    ti, tj = i + di, j + dj
    next unless i_range.include?(ti) && j_range.include?(tj) && height_map[ti, tj] >= hlimit
    if distances[ti, tj] > distance
      distances[ti, tj] = distance
      insert_queue(queue, [ti, tj], distance)
    end
  }
end
p distances[*start_position]
p distances.each_with_index.filter { |_, i, j| height_map[i, j] == 0 }.map { |d, _, _| d }.min
