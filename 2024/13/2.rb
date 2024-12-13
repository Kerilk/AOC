machines = File.read('input').split("\n\n").map { |t|
  t.match(/Button A: X\+(\d+), Y\+(\d+)\nButton B: X\+(\d+), Y\+(\d+)\nPrize: X=(\d+), Y=(\d+)/m)[1..6].map(&:to_i).each_slice(2).map { |i, j| Complex(i, j) }
}

p machines.sum { |a, b, p|
  catch(:found) do
    (1..100).each { |i|
      (1..100).each { |j|
        throw :found, 3*i + j if p == i * a + j * b
      }
    }
    0
  end
}

p machines.map { |a, b, p| [a, b, p + 10000000000000 * (1 + 1i)].map(&:rect) }.sum { |(x1, y1), (x2, y2), (x, y)|
  alpha, rema = (x2*y-y2*x).divmod(x2*y1 - x1*y2)
  beta, remb = (x1*y-y1*x).divmod(x1*y2 - x2*y1)
  rema == 0 && remb == 0 ? 3 * alpha + beta : 0
}
