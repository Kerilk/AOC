require 'set'

blocks = File.read('input').each_line.map { |l| l.split('~').map { |tr| tr.split(',').map(&:to_i) }.transpose.map { |a, b| a..b } }.sort { |(_, _, z1), (_, _, z2)| z1.begin <=> z2.begin }

x_count, y_count, z_count = blocks.transpose.map { |ranges| ranges.map { |range| range.end + 1 }.max }

board = x_count.times.inject([]) { |memo, _|
  memo.push(y_count.times.inject([]) { |memo2, _|
    memo2.push [-1] + [false] * (z_count-1)
  })
}

fallen_blocks = blocks.each_with_index.map { |(rx, ry, rz), i|
  while !rx.to_a.product(ry.to_a, rz.to_a).map.any? { |x, y, z| board[x][y][z-1] }
    rz = (rz.begin-1)..(rz.end-1)
  end
  rx.to_a.product(ry.to_a, rz.to_a).each { |x, y, z| board[x][y][z] = i }
  [rx, ry, rz]
}

supports = fallen_blocks.each_with_index.map { |(rx, ry, rz), i|
  rx.to_a.product(ry.to_a, rz.to_a).filter_map { |x, y, z| board[x][y][z-1] }.reject { |v| v == i }.to_set
}

critical = supports.filter_map {  |support| support.first if support.size == 1 }.uniq - [-1]
expendable = (0...fallen_blocks.size).to_a - critical
p expendable.size

p critical.map { |b|
  falling = Set[b]
  supports[(b+1)..-1].each.with_index(b+1) { |support, i| falling.add(i) if (falling & support) == support }
  falling.size - 1
}.sum
