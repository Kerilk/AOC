require 'narray'

$syms = {}

class Tile
  attr_reader :sides
  attr_reader :reverse_sides
  attr_reader :id
  attr_reader :pattern
  attr_reader :size
  def initialize(id, pattern)
    @id = id
    @pattern = pattern
    @size = @pattern.length
    compute_sides
    compute_reverse_sides
    set_syms
  end

  def side_to_i(arr)
    arr.join.to_i(2)
  end

  def compute_sides
    @sides = []
    @sides[0] = side_to_i(@pattern[0])
    @sides[1] = side_to_i(@size.times.collect { |i| @pattern[i].last })
    @sides[2] = side_to_i(@pattern[-1].reverse)
    @sides[3] = side_to_i(@size.times.collect { |i| @pattern[i].first }.reverse)
  end

  def compute_reverse_sides
    @reverse_sides = []
    @reverse_sides[0] = side_to_i(@pattern[0].reverse)
    @reverse_sides[1] = side_to_i(@size.times.collect { |i| @pattern[i].first })
    @reverse_sides[2] = side_to_i(@pattern[-1])
    @reverse_sides[3] = side_to_i(@size.times.collect { |i| @pattern[i].last }.reverse)
  end

  def set_syms
    4.times { |i|
      $syms[@sides[i]] = @reverse_sides[-i]
      $syms[@reverse_sides[-i]] = @sides[i]
    }
  end

  def rotate!
    @pattern = @pattern.transpose.collect { |r| r.reverse }
    @sides.rotate!(-1)
    @reverse_sides.rotate!
    self
  end

  def sym!
    @pattern.collect! { |r| r.reverse }
    @sides, @reverse_sides = @reverse_sides, @sides
    self
  end
end

d = File.read('input').split("\n\n").collect { |b|
  t = b.split("\n")
  id = t[0].match(/Tile (\d+):/)[1].to_i
  pattern = t[1..-1].collect { |l| l.each_char.collect { |c| c == "#" ? 1 : 0 } }
  Tile.new(id, pattern)
}

sides = d.collect { |t| t.sides + t.reverse_sides }.reduce(:+).tally
#puts sides.values.reduce(:+)
#puts 144 * 4 * 2
#puts sides.size
#puts ((11*12)*2+12*4)*2
corners = d.select { |t| t.sides.collect { |s| sides[s] }.reduce(:+) == 6 }
puts corners.collect(&:id).reduce(:*)
to_place = d.dup
to_place.delete(corners[0])
board_size = Math.sqrt(d.size).to_i
board = board_size.times.collect { [] }
c = board[0][0] = corners[0]
while sides[c.sides[1]] + sides[c.sides[2]] != 4
  c.rotate!
end

find_and_position = lambda { |v, face|
  v = $syms[v]
  to_place.find { |t|
    if t.sides.include?(v)
      while t.sides[face] != v
        t.rotate!
      end
      t
    elsif t.reverse_sides.include?(v)
      t.sym!
      while t.sides[face] != v
        t.rotate!
      end
      t
    else
      nil
    end
  }
}

(1...board_size).each { |j|
  v = board[0][j-1].sides[1]
  t = find_and_position.call(v, -1)
  board[0][j] = t
  to_place.delete(t)
}
(1...board_size).each { |i|
  (0...board_size).each { |j|
    v = board[i-1][j].sides[2]
    t = find_and_position.call(v, 0)
    board[i][j] = t
    to_place.delete(t)
  }
}

tile_size = d.first.size - 2
pattern = (board_size * tile_size).times.collect { [] }
(0...board_size).each { |i|
  (0...board_size).each { |j|
    t = board[i][j]
    tile_size.times { |x|
      tile_size.times { |y|
        pattern[i*tile_size + x][j*tile_size + y] = t.pattern[x+1][y+1]
      }
    }
  }
}
#pattern.each { |l| puts l.collect { |c| c == 1 ? "#" : "." }.join }

monster_img = <<EOF
                  # 
#    ##    ##    ###
 #  #  #  #  #  #   
EOF

monster_pattern = monster_img.split("\n").collect { |l| l.each_char.collect { |c| c == "#" ? 1 : 0 } }
full_tile = Tile.new(0, pattern)

search = lambda { |patt, mpatt|
  m_pattern = patt.collect { |l| l.dup }
#  m_pattern.each { |l| puts l.collect { |c| c == 2 ? "O" : c == 1 ? "#" : "." }.join }
#  puts
  count = 0
  (0..(patt.size - mpatt.size)).each { |i|
    (0..(patt.size - mpatt[0].size)).each { |j|
      found = true
      (0...mpatt.size).each { |x|
        (0...mpatt[0].size).each { |y|
          found = false unless mpatt[x][y] == 0 || patt[i+x][j+y] == 1
        }
      }
      if found
        count += 1
        (0...mpatt.size).each { |x|
          (0...mpatt[0].size).each { |y|
            m_pattern[i+x][j+y] = 2 unless mpatt[x][y] == 0
          }
        }
      end
    }
  }
#  if count > 0
#    m_pattern.each { |l| puts l.collect { |c| c == 2 ? "O" : c == 1 ? "#" : "." }.join }
#  end
  count
}
c = 0
2.times {
  4.times {
    c = search.call(full_tile.pattern, monster_pattern)
    break if c > 0
    full_tile.rotate!
  }
  break if c > 0
  full_tile.sym!
}
puts pattern.collect { |l| l.count { |v| v==1 } }.reduce(:+) -  c * monster_pattern.collect { |l| l.count { |v| v==1 } }.reduce(:+)
