require 'matrix'

map = Matrix[*File.read('input').each_line.map(&:chomp).map(&:chars)]
start = map.index { |e| e == "S" }.yield_self { |i, j| Complex(i, j) }
end_pos   = map.index { |e| e == "E" }.yield_self { |i, j| Complex(i, j) }
start_dir = 1i
directions = [1,-1, 1i, -1i]

def insert_queue(queue, position, direction, score)
  queue.insert(queue.bsearch_index { |_, _, s| s >= score } || queue.size, [position, direction, score])
end

score_map = Matrix.build(map.row_count, map.column_count) { |i, j| Hash.new { |h, k| h[k] = Float::INFINITY } }
queue = [[start, start_dir, 0]]
score_map[*start.rect][start_dir] = 0
while !queue.empty?
  position, direction, score = queue.shift
  ([[position + direction, direction, score + 1]] +
   [1i, -1i].map { |t| [position, direction * t, score + 1000] }).each do |p, d, s|
    if map[*p.rect] != '#' && score_map[*p.rect][d] > s
      insert_queue(queue, p, d, s)
      score_map[*p.rect][d] = s
    end
  end
end
p min = score_map[*end_pos.rect].values.min

best = Set[end_pos]
queue = score_map[*end_pos.rect].each.filter { |k, v| v == min }.map { |k, _| [end_pos, k, min] }
while !queue.empty?
  position, direction, score = queue.shift
  ([[position - direction, direction, score - 1]] +
   [1i, -1i].map { |t| [position, direction * t, score - 1000] }).each do |p, d, s|
    if score_map[*p.rect][d] == s
      queue << [p, d, s]
      best.add p
    end
  end
end
p best.size
