p File.read('input').split(',').map { |e| Range.new(*e.split('-').map(&:to_i)) }.flat_map { |range|
    range.map(&:to_s).select { |id|
      (idl = id.length) && idl % 2 == 0 && id[0...(idl/2)] == id[(idl/2)...idl]
    }.map(&:to_i)
  }.sum
