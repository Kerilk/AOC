require 'matrix'

SIZE = 71
MAP = Matrix.build(SIZE, SIZE) { |i, j| [Float::INFINITY, Float::INFINITY] }
BOUNDS = 0...SIZE
START = 0+0i
END_POS = SIZE-1 + (SIZE-1)*1i
DIRECTIONS = [1, -1, 1i, -1i]

bytes = File.read('input').scan(/\d+/).map(&:to_i).each_slice(2).map { |x, y| Complex(x, y) }
bytes[0...1024].each_with_index { |p, i| MAP[*p.rect][1] = i }

def insert_queue(queue, position, score)
  queue.insert(queue.bsearch_index { |_, s| s >= score } || queue.size, [position, score])
end

queue = [[START, 0]]
MAP[*START.rect][0] = 0
while !queue.empty?
  position, score = queue.shift
  score += 1
  DIRECTIONS.map { |d| d + position }.each { |p|
    if BOUNDS.include?(p.real) && BOUNDS.include?(p.imag)
      s, t = MAP[p.real, p.imag]
      if t == Float::INFINITY && s > score
        insert_queue(queue, p, score)
        MAP[p.real, p.imag][0] = score
      end
    end
  }
end

p MAP[*END_POS.rect][0]