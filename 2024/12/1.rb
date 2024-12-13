queue = Set.new
File.read('input').each_line.with_index { |l, i|
  l.chomp.chars.each_with_index { |c, j|
    queue.add [Complex(i, j), c]
  }
}
regions = []
while area = queue.first
  region = Set[area]
  added = region.dup
  queue.delete(area)
  count = 0
  while !added.empty?
    added, count = added.reduce([Set.new, count]) { |memo, (x, c)|
      [-1, 1, 1i, -1i].reduce(memo) { |(set, n), d|
        o = [x+d, c]
        if queue.delete?(o)
          set.add o
        elsif !region.include?(o) && !set.include?(o)
          n += 1
        end
        [set, n] 
      }
    }
    region.merge(added)
  end
  regions << [region, count]
end
p regions.sum { |set, count|
  set.size * count
}
