require 'matrix'
field = Matrix[*File.read('input').each_line.map(&:strip).map(&:chars)]
field.each_with_index { |e, i, j|
  if (e == 'S' || e == '|') && i < field.row_count - 1
    below = field[i + 1, j]
    if below == '.'
      field[i + 1, j] = '|'
    elsif below == '^'
      field[i + 1, j - 1] = '|'
      field[i + 1, j + 1] = '|'
    end
  end
}
p field.each_with_index.count { |e, i, j| e == '^' && field[i - 1, j] == '|'}
