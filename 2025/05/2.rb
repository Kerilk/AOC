ranges, _ = File.read('input').split("\n\n")
ranges = ranges.each_line.map { |l| Range.new(*l.split('-').map(&:to_i)) }.sort_by(&:first)
p ranges[1..-1].reduce([ranges.first]) { |memo, r2|
  r = memo.last.last >= r2.first ? (memo.last.last+1)..r2.last : r2
  r.last < r.first ? memo : memo << r
}.sum(&:size)
