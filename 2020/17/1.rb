require 'narray'

def cycle(source, target)
  dim = source.dimension
  stencil = ([-1, 0, 1].product(*([[-1, 0, 1]]*(dim-1))) - [[0]*dim]).collect { |v| NArray.to_na(v) }
  shape = source.shape
  l = lambda { |pos, depth|
    depth -= 1
    (1...(shape[depth]-1)).each { |x|
      fpos = pos.dup
      fpos[depth] = x
      if depth > 0
        l.call(fpos, depth)
      else
        neigh = stencil.collect { |vec| source[*(fpos + vec)] }.reduce(:+)
        target[*fpos] = if source[*fpos] == 1
            neigh.between?(2,3) ? 1 : 0
          else
            neigh == 3 ? 1 : 0
          end
      end
    }
  }
  l.call(NArray.int(dim), dim)
end

d = File.read('input').each_line.collect { |l| l.chomp.each_char.collect { |c| c == "#" ? 1 : 0 } }
height = d.size
width = d[0].size

dims = 4
cycles = 6

halo = cycles + 1
shape = [width + 2 * halo, height + 2 * halo]
shape += [1 + 2 * halo] * (dims - 2)

source = NArray.sint(*shape)
target = NArray.sint(*shape)
pad = [halo] * (dims - 2)
d.each_with_index { |l, y|
  l.each_with_index { |v, x|
    source[x + halo, y + halo, *pad] = v
  }
}

cycles.times {
  cycle(source, target)
  source, target = target, source
}
puts source.sum
