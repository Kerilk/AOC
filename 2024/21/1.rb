p codes = File.read('input').each_line.map(&:chomp)

keypad1 = {
 '7' => Complex(0, 0),
 '8' => Complex(0, 1),
 '9' => Complex(0, 2),
 '4' => Complex(1, 0),
 '5' => Complex(1, 1),
 '6' => Complex(1, 2),
 '1' => Complex(2, 0),
 '2' => Complex(2, 1),
 '3' => Complex(2, 2),
 'X' => Complex(3, 0),
 '0' => Complex(3, 1),
 'A' => Complex(3, 2),
}

keypad2 = {
  'X' => Complex(0, 0),
  '^' => Complex(0, 1),
  'A' => Complex(0, 2),
  '<' => Complex(1, 0),
  'v' => Complex(1, 1),
  '>' => Complex(1, 2),
}

MOVES = {
  Complex(-1,  0) => '^',
  Complex( 1,  0) => 'v',
  Complex( 0,  1) => '>',
  Complex( 0, -1) => '<',
}

keypads = [keypad1, keypad2, keypad2]
positions = ['A', 'A', 'A']

def press(key, index, keypads, positions)
  keypad = keypads[index]
  pos = keypad[positions[index]]
  forbidden = keypad['X']
  delta = keypad[key] - pos
  positions[index] = key
  path =
    (delta.real < 0 ? [Complex(-1,  0)] * -delta.real : [Complex( 1,  0)] * delta.real) +
    (delta.imag < 0 ? [Complex( 0, -1)] * -delta.imag : [Complex( 0,  1)] * delta.imag)
  path.permutation.uniq.reject { |p|
    mem = pos
    p.any? { |d| forbidden == (mem += d) }
  }.map { |p|
    p.map { |d| MOVES[d] }.join + 'A'
  }.map { |c|
    input(c, index + 1, keypads, positions)
  }.sort_by(&:length).first
end

def input(code, index, keypads, positions)
  return code if index == keypads.length
  code.chars.sum('') { |c| press(c, index, keypads, positions) }
end

p codes.sum { |c|
  p code = input(c, 0, keypads, positions.dup)
  p code.length
  c.to_i * code.length
}
