require 'matrix'

codes = File.read('input').each_line.map(&:chomp)

keypad1 = Matrix[
  ['7', '8', '9'],
  ['4', '5', '6'],
  ['1', '2', '3'],
  ['X', '0', 'A']
].each_with_index.map { |e, row, col| [e, Complex(row, col)] }.to_h

keypad2 = Matrix[
  ['X', '^', 'A'],
  ['<', 'v', '>']
].each_with_index.map { |e, row, col| [e, Complex(row, col)] }.to_h

MOVES = {
  Complex(-1,  0) => '^',
  Complex( 1,  0) => 'v',
  Complex( 0,  1) => '>',
  Complex( 0, -1) => '<',
}

$memo = {}
def press(key, tkey, keypads)
  $memo[[key, tkey, keypads.size]] ||= begin
    keypad, *keypads = *keypads
    pos, tpos, forbidden = *[key, tkey, 'X'].map{ |k| keypad[k] }
    delta = tpos - pos
    path =
      [Complex(1, 0) * (delta.real <=> 0)] * delta.real.abs +
      [Complex(0, 1) * (delta.imag <=> 0)] * delta.imag.abs
    path.permutation.uniq.reject { |p|
      mem = pos
      p.any? { |d| forbidden == (mem += d) }
    }.map { |p|
      p.map { |d| MOVES[d] }.join + 'A'
    }.map { |code|
      input(code, keypads)
    }.min
  end
end

def input(code, keypads)
  return code.length if keypads.empty?
  ('A' << code).chars.each_cons(2).sum { |key, tkey| press(key, tkey, keypads) }
end

keypads = [keypad1] + [keypad2] * 25
p codes.sum { |code|
  code.to_i * input(code, keypads)
}
