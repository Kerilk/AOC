p File.read('input').each_line.map(&:strip).map(&:chars).sum { |batteries|
  12.times.reduce(['', batteries]) { |(res, batts), i|
    res << batts[0..(-12+i)].max
    [res, batts[(batts.index(res[-1]) + 1)..-1]]
  }.first.to_i
}
