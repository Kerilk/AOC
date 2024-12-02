instructions = File.read("./input").each_line.collect { |l|
  m = l.match(/(\d+),(\d+) through (\d+),(\d+)/)
  [l.match(/on|off|toggle/)[0].to_sym, m[1..4].collect(&:to_i)]
}

area = 1000.times.collect { 1000.times.collect { false } }
off = lambda { |v| false }
on = lambda { |v| true }
toggle = lambda { |v| v ? false : true }
op_map = { on: on, off: off, toggle: toggle }

instructions.each { |op, (x1, y1, x2, y2)|
  p = op_map[op]
  (x1..x2).each { |x|
    (y1..y2).each { |y|
      area[x][y] = p.call(area[x][y])
    }
  }
}

puts area.flatten.count { |v| v }
