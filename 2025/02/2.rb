p File.read('input').split(',').map { |e| Range.new(*e.split('-').map(&:to_i)) }.flat_map { |range|
    range.map(&:to_s).select { |id|
      (idl = id.length) && (1..(idl/2)).any? { |l|
        idl % l == 0 && id.chars.each_slice(l).uniq.size == 1
        #idl % l == 0 && (idl/l).times.map { |i| id[(i*l)...((i+1)*l)] }.uniq.size == 1
      }
    }.map(&:to_i)
  }.sum
