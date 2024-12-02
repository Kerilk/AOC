require 'matrix'

instrs = File.read('./input').scan(/([NSEWLRF])(\d+)/).collect { |op, val| [op.to_sym, val.to_i] }
ORIGIN = Vector[ 0,  0]
NORTH = Vector[ 1,  0]
SOUTH = Vector[-1,  0]
EAST  = Vector[ 0,  1]
WEST  = Vector[ 0, -1]
pos = ORIGIN.dup
wpos = 1 * NORTH + 10 * EAST
rots = {
  0   => Matrix[ [ 1,  0], [ 0,  1] ],
  90  => Matrix[ [ 0, -1], [ 1,  0] ],
  180 => Matrix[ [-1,  0], [ 0, -1] ],
  270 => Matrix[ [ 0,  1], [-1,  0] ] }
ops = {
  N: lambda { |val| wpos += val * NORTH },
  S: lambda { |val| wpos += val * SOUTH },
  E: lambda { |val| wpos += val * EAST },
  W: lambda { |val| wpos += val * WEST },
  F: lambda { |val| pos += val * wpos },
  R: lambda { |val| wpos = rots[val % 360] * wpos },
  L: lambda { |val| wpos = rots[(360 - val) % 360] * wpos } }
instrs.each { |instr| ops[instr[0]][instr[1]] }
v = pos - ORIGIN
puts v[0].abs + v[1].abs
