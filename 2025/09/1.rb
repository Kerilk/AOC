require 'matrix'
tiles = File.read('input').each_line.map { |l| Vector[*l.split(',').map(&:to_i)] }
p tiles.combination(2).map { |t1, t2| t2-t1 }.map { |v| v.map(&:abs).map(&1.method(:+)).reduce(:*) }.max
