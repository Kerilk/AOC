require 'matrix'

map, instructions = File.read('input').split("\n\n").yield_self { |m, instr|
  [Matrix[*m.gsub('#', '##').gsub('O', '[]').gsub('.', '..').gsub('@', '@.').each_line.map(&:chomp).map(&:chars)], instr.tr("\n", "").chars]
}
start = map.index { |e| e == "@" }.yield_self { |i, j| Complex(i, j) }
instr_map = { "^" => -1, "v" => 1, ">" => 1i, "<" => -1i }
instructions.map! { |i| instr_map[i] }

def try_move(map, pos, dir)
  case map[*(pos+dir).rect]
  when "#"
    return false
  when "["
    if dir == 1i
      return false unless try_move(map, pos+2*dir, dir)
    else
      return false unless try_move(map, pos + dir, dir) && try_move(map, pos + dir + 1i, dir)
    end
  when "]"
    if dir == -1i
      return false unless try_move(map, pos+2*dir, dir)
    else
      return false unless try_move(map, pos + dir, dir) && try_move(map, pos + dir - 1i, dir)
    end
  end
  return true
end

def move(map, pos, dir)
  case map[*(pos+dir).rect]
  when "["
    if dir == 1i
      move(map, pos + 2*dir, dir)
      move(map, pos +   dir, dir)
    else
      move(map, pos + dir, dir)
      move(map, pos + dir + 1i, dir)
    end
  when "]"
    if dir == -1i
      move(map, pos + 2*dir, dir)
      move(map, pos +   dir, dir)
    else
      move(map, pos + dir, dir)
      move(map, pos + dir - 1i, dir)
    end
  end
  map[*pos.rect], map[*(pos+dir).rect] = map[*(pos+dir).rect], map[*pos.rect]
end

pos = start
instructions.each { |i|
  if try_move(map, pos, i)
     move(map, pos, i)
     pos += i
  end
}
p map.each_with_index.filter { |e, _, _| e == '[' }.sum { |_, i, j| i*100 + j }
