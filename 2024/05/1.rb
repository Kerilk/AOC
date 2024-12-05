rules, updates = File.read('input').split("\n\n").yield_self { |r, u|
    [r.each_line.map { |l| l.split('|').map(&:to_i) },
     u.each_line.map { |l| l.split(',').map(&:to_i) }]
  }
ancestors = rules.reduce(Hash.new { |h, k| h[k] = Set.new }){ |memo, (a, b)| memo[b] << a; memo }
p updates.filter { |u|
  u.each_with_index.all? { |p, i| (u[i..-1].to_set & ancestors[p]).empty? }
}.map{ |u| u[u.size/2] }.sum
