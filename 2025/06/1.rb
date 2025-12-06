p File.read('input').each_line.map(&:strip).map { |l| l.split(/ +/) }.transpose.
    sum { |*args, op| args.map(&:to_i).reduce(op.to_sym) }
