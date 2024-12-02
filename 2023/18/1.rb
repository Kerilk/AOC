require 'matrix'
require 'set'

U = Vector[-1,  0]
D = Vector[ 1,  0]
R = Vector[ 0,  1]
L = Vector[ 0, -1]
directions = [R, D, L, U]

instructions1, instructions2 = File.read('input').each_line.map { |l|
  l.match(/([RLDU]) (\d+) \(#(\h+)\)/)[1..3]
}.map { |d, count, color|
  [[eval(d), count.to_i], color.to_i(16).yield_self { |col| [directions[col & 0x7], col >> 4] }]
}.transpose

def to_vertices(instructions)
  instructions.inject([Vector[0,0]]) { |memo, (dir, count)| memo.push (memo.last + count * dir) }
end

def compute_surface(vertices)
  vertices.each_cons(2).map { |a, b| a[0] * b[1] - a[1] * b[0] }.sum.abs / 2 +
  vertices.each_cons(2).map { |a, b| (b - a).sum }.map(&:abs).sum / 2 + 1
end

p compute_surface(to_vertices(instructions1))
p compute_surface(to_vertices(instructions2))
