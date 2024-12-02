bag = {'red' => 12, 'green' => 13, 'blue' => 14}

games = File.read('input').each_line.with_index(1).map { |l, i|
  [
    i,
    l.split(':')[1].split(';').map { |g|
      g.split(",").map {
        |e| e.match(/(\d+) (blue|red|green)/) }.map { |m|
          [m[2], m[1].to_i]
         }.to_h
    }
  ]
}.to_h

p games.select { |k, v|
  v.all? { |round|
    round.all? { |color, count| bag[color] >= count }
  }
}.keys.sum

p games.values.map { |rounds|
  rounds.reduce { |memo, r|
    r.each { |k, v| memo[k] = [(memo[k] || 0), v].max }
    memo
  }.values.reduce(:*)
}.sum

