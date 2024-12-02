require 'matrix'

instrs = File.read('./input').scan(/([NSEWLRF])(\d+)/).collect { |op, val| [op.to_sym, val.to_i] }
ORIGIN = Vector[ 0,  0]
NORTH = Vector[ 1,  0]
SOUTH = Vector[-1,  0]
EAST  = Vector[ 0,  1]
WEST  = Vector[ 0, -1]
pos = ORIGIN.dup
dir = EAST.dup
rots = {
  0   => Matrix[ [ 1,  0], [ 0,  1] ],
  90  => Matrix[ [ 0, -1], [ 1,  0] ],
  180 => Matrix[ [-1,  0], [ 0, -1] ],
  270 => Matrix[ [ 0,  1], [-1,  0] ] }
ops = {
  N: lambda { |val| pos += val * NORTH },
  S: lambda { |val| pos += val * SOUTH },
  E: lambda { |val| pos += val * EAST },
  W: lambda { |val| pos += val * WEST },
  F: lambda { |val| pos += val * dir },
  R: lambda { |val| dir = rots[val % 360] * dir },
  L: lambda { |val| dir = rots[(360 - val) % 360] * dir } }
instrs.each { |instr| ops[instr[0]][instr[1]] }
v = pos - ORIGIN
puts v[0].abs + v[1].abs
