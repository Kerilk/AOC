require 'matrix'
field = Matrix[*File.read('input').each_line.map(&:strip).map(&:chars)]
field.collect! { |e| e == 'S' ? 1 : e == '.' ? 0 : -1 }
field.each_with_index { |e, i, j|
  if e > 0 && i < field.row_count - 1
    if field[i + 1, j] >= 0
      field[i + 1, j] += e
    else
      field[i + 1, j - 1] += e
      field[i + 1, j + 1] += e
    end
  end
}
p field.row(-1).sum
