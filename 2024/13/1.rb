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
