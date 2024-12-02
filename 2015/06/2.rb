instructions = File.read("./input").each_line.collect { |l|
  m = l.match(/(\d+),(\d+) through (\d+),(\d+)/)
  [l.match(/on|off|toggle/)[0].to_sym, m[1..4].collect(&:to_i)]
}

area = 1000.times.collect { 1000.times.collect { 0 } }
off = lambda { |v| v - 1 < 0 ? 0 : v - 1 }
on = lambda { |v| v + 1 }
toggle = lambda { |v| v + 2 }
op_map = { on: on, off: off, toggle: toggle }

instructions.each { |op, (x1, y1, x2, y2)|
  p = op_map[op]
  (x1..x2).each { |x|
    (y1..y2).each { |y|
      area[x][y] = p.call(area[x][y])
    }
  }
}

puts area.flatten.sum
