p File.read('input').each_line.map(&:chomp).map(&:chars).map(&:reverse).transpose.
  each { |entry| entry.delete(" ") }.map(&:join).reduce([[]]) { |memo, e|
    case e
    when ""   ; memo << []
    when /\d$/; memo.last << e
    else      ; memo.last << e[0..-2] << e[-1]
    end
    memo
  }.sum { |*args, op| args.map(&:to_i).reduce(op.to_sym) }
