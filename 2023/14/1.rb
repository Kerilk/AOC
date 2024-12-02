require 'matrix'

panel = Matrix[*File.read('input').each_line.map(&:strip).map(&:chars)]

def tilt_north(panel)
  panel.each_with_index { |c, i, j|
    if c == 'O'
      panel[i, j] = '.'
      while i > 0 && panel[i-1, j] == '.'
        i -= 1
      end
      panel[i, j] = 'O'
    end
  }
end

def tilt_west(panel)
  panel.each_with_index { |c, i, j|
    if c == 'O'
      panel[i, j] = '.'
      while j > 0 && panel[i, j-1] == '.'
        j -= 1
      end
      panel[i, j] = 'O'
    end
  }
end

def tilt_south(panel)
  panel.each_with_index.reverse_each { |c, i, j|
    if c == 'O'
      panel[i, j] = '.'
      while i < panel.column_count - 1 && panel[i+1, j] == '.'
        i += 1
      end
      panel[i, j] = 'O'
    end
  }
end

def tilt_east(panel)
  panel.each_with_index.reverse_each { |c, i, j|
   if c == 'O'
     panel[i, j] = '.'
     while j < panel.row_count - 1 && panel[i, j+1] == '.'
       j += 1
     end
     panel[i, j] = 'O'
   end
  }
end

def beam_load(panel)
  panel.each_with_index.filter_map { |c, i, j|
    panel.row_count - i if c == 'O'
  }.sum
end

def print_panel(panel)
  puts
  panel.row_vectors.each { |v| puts v.each.to_a.join }
end

tilt_north(panel)
puts beam_load(panel)
print_panel(panel)

@memo = {}
def cycle(panel, count)
  @memo[[panel, count]] ||= begin
    if count == 1
      new_pan = panel.dup
      tilt_north(new_pan)
      tilt_west(new_pan)
      tilt_south(new_pan)
      tilt_east(new_pan)
      new_pan
    else
      new_pan = cycle(panel, count >> 1)
      cycle(new_pan, count - (count >> 1))
    end
  end
end

res = cycle(panel, 1000000000)
print_panel(res)
puts beam_load(res)
