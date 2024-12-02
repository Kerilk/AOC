seeds, *maps = File.read('ref').split("\n\n")
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
