class Complex
  def %(a)
    a = a.to_c
    Complex(self.real % a.real, self.imag % a.imag)
  end
end

robots = File.read('input').each_line.map { |l| l.scan(/[+-]?\d+/).map(&:to_i).each_slice(2).map {|x, y| Complex(x, y) } }
width, height = 101, 103
floor = Complex(width, height)
quandrants = [true, false].product([true, false]).map { |l|
  l.zip([width, height]).map { |first, dim| first ? 0...(dim/2) : (dim/2+1)...dim }
}

p 100.times.reduce(robots) { |memo, i|
  memo.map { |p, v| [(p+v)%floor, v] }
}.reduce([0]*4) { |memo, (p, v)|
  i = quandrants.find_index { |w, h| w.include?(p.real) && h.include?(p.imag) }
  memo[i] += 1 if i
  memo
}.reduce(:*)
