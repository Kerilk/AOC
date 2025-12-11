machines = File.read('input').each_line.map { |l|
  [ l.match(/\[(.*?)\]/)[1].chars.map { |c| c == '#' },
    l.scan(/\(([0-9,]+)\)/).flatten.map { |s| s.split(",").map(&:to_i) } ]
}
transition = lambda { |state, button|
  button.reduce(state.dup) { |memo, light| memo[light] = !memo[light]; memo }
}
p machines.sum { |(target, buttons)|
  (1..buttons.size).find { |sz|
    buttons.combination(sz).map { |presses|
      presses.reduce([false]*target.size) { |memo, button| transition[memo, button] }
    }.include?(target)
  }
}
