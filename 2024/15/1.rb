require 'matrix'

map, instructions = File.read('input').split("\n\n").yield_self { |m, instr|
  [Matrix[*m.each_line.map(&:chomp).map(&:chars)], instr.tr("\n", "").chars]
}
start = map.index { |e| e == "@" }.yield_self { |i, j| Complex(i, j) }
instr_map = { "^" => -1, "v" => 1, ">" => 1i, "<" => -1i }
instructions.map! { |i| instr_map[i] }

def move(map, pos, dir)
  case map[*(pos+dir).rect]
  when "#"
    return false
  when "O"
    return false if !move(map, pos+dir, dir)
  end
  map[*pos.rect], map[*(pos+dir).rect] = map[*(pos+dir).rect], map[*pos.rect]
  return true
end

pos = start
instructions.each { |i|
  pos += i if move(map, pos, i)
}
p map.each_with_index.filter { |e, _, _| e == 'O' }.sum { |_, i, j| i*100 + j }
