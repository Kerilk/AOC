require 'matrix'

panel = Matrix[*File.read('input').each_line.map(&:strip).map(&:chars)]

def tilt(panel)
  panel = panel.dup
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

def rotate(panel)
  Matrix.build(panel.row_count) { |i, j| panel[panel.row_count - j - 1, i] }
end

def beam_load(panel)
  panel.each_with_index.filter_map { |c, i, j|
    panel.row_count - i if c == 'O'
  }.sum
end

@memo = {}
def cycle(panel, count)
  @memo[[panel, count]] ||= begin
    if count == 1
      4.times { 
        panel = rotate(tilt(panel))
      }
      panel
    else
      cycle(cycle(panel, count >> 1), count - (count >> 1))
    end
  end
end

puts beam_load(tilt(panel))
puts beam_load(cycle(panel, 1000000000))
