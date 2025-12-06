p File.read('input').each_line.map(&:strip).map(&:chars).sum { |batts|
  batts.combination(2).map(&:join).map(&:to_i).max
}
