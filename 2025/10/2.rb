require 'rulp'
Rulp::log_level = Logger::ERROR

machines = File.read('input').each_line.map { |l|
  [ target = l.match(/{([0-9,]+)}/)[1].split(",").map(&:to_i),
    l.scan(/\(([0-9,]+)\)/).flatten.map { |s|
      s.split(",").map(&:to_i).reduce([0]*target.size) { |memo, i|
        memo[i] +=1
        memo
      }
    } ]
}

p machines.sum { |(target, buttons)|
  variables = buttons.size.times.map { |i| IV.definition("X#{i}") }
  given[variables.map { |i| i >= 0 }]
  constraints = target.each_with_index.map { |v, i|
    variables.each_with_index.map { |var, j|
      var * buttons[j][i]
    }.reduce(:+) == v
  }
  objective = variables.reduce(:+)
  Rulp::Glpk(Rulp::Min(objective)[constraints])
}.round
