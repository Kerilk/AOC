class Complex
  def %(a)
    a = a.to_c
    Complex(self.real % a.real, self.imag % a.imag)
  end
end

robots = File.read('input').each_line.map { |l| l.scan(/[+-]?\d+/).map(&:to_i).each_slice(2).map {|x, y| Complex(x, y) } }
width, height = 101, 103
floor = Complex(width, height)
p (width*height).times.map { |i|
  robots.map! { |p, v| [(p+v)%floor, v] }
  delta = floor/2 - robots.map(&:first).sum/robots.size
  [i, delta.magnitude]
}.max_by { |_, delta| delta }[0] + 1
