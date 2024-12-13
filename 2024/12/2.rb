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
  fences = Set.new
  while !added.empty?
    added, count, fences = added.reduce([Set.new, count, fences]) { |memo, (x, c)|
      [-1, 1, 1i, -1i].reduce(memo) { |(set, n, f), d|
        o = [x+d, c]
        if queue.delete?(o)
          set.add o
        elsif !region.include?(o) && !set.include?(o)
          f.add [x, x+d]
          n += 1
        end
        [set, n, f] 
      }
    }
    region.merge(added)
  end
  regions << [region, count, fences]
end
p regions.sum { |set, count, fences|
  set.size * count
}
p regions.sum { |set, count, fences|
  sides = 0
  while fence = fences.first
    added = Set[fence]
    fences.delete(fence)
    while !added.empty?
      added = added.reduce(Set.new) { |memo, (x, y)|
        v = (y-x)
        [-1i, 1i].reduce(memo) { |s, d|
          o = [x+d*v, y+d*v]
          s.add(o) if fences.delete?(o)
          s
        }
      }
    end
    sides += 1
  end
  set.size * sides
}
