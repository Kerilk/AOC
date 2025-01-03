require 'matrix'

mats = File.read('input').split("\n\n").map { |b|
  Matrix[*b.split("\n").map { |l| l.tr('.', '0').tr('#', '1').chars.map(&:to_i) }]
}

p mats.combination(2).map { |l, k| l + k }.reject { |m| m.find { |i| i > 1 } }.size
