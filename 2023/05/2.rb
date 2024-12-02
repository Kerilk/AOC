seeds, *maps = File.read('input').split("\n\n")
seeds = seeds.scan(/\d+/).map(&:to_i)
maps = maps.map { |m|
  m.scan(/^\d+ \d+ \d+$/).map { |l|
    l.split(' ').map(&:to_i)
  }.map { |dest, source, size|
    [source...(source+size), dest...(dest+size)]
  }
}

p seeds.map { |s|
  maps.inject(s) { |memo, map|
    rgs = map.find { |source, _| source.include?(memo) }
    rgs ? rgs[1].begin + memo - rgs[0].begin : memo
  }
}.min

p maps.reduce(seeds.each_slice(2).map { |start, size| start...(start+size) }) { |inputs, map|
  new_inputs = []
  while (input = inputs.pop)
    if rgs = map.find { |src, _| input.begin < src.end && input.end > src.begin }
      src, dst = rgs
      begin_mapped, last_mapped = src.include?(input.begin), src.include?(input.last)
      new_inputs.push (dst.begin + (begin_mapped ? input.begin - src.begin : 0))...(dst.end - (last_mapped ? src.end - input.end : 0))
      inputs.push src.end...input.end unless last_mapped
      inputs.push input.begin...src.begin unless begin_mapped
    else
      new_inputs.push(input)
    end
  end
  new_inputs
}.map(&:begin).min
