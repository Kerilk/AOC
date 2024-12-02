series = File.read('input').each_line.map { |l| l.scan(/-?\d+/).map(&:to_i) }

derivatives = series.map { |s|
  values = [s]
  while !values.last.all?(&:zero?)
    values.push( values.last.each_cons(2).map { |a, b| b - a } )
  end
  values
}

p derivatives.map { |values|
  values.map(&:last).sum
}.sum

p derivatives.map { |values|
  values.map(&:first).reverse.reduce(0) { |memo, v| v - memo }
}.sum
