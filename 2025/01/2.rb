p File.read('input').tr('L','-').tr('R','').each_line.map(&:to_i).reduce([[0, 50]]) { |memo, shift|
  old = memo.last[1]
  count, pos = (old + shift).divmod(100)
  count = count.abs + (old == 0 ? -1 : pos == 0 ? 1 : 0) if shift < 0
  memo << [count, pos]
}.map(&:first).sum
