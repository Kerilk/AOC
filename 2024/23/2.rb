connections = File.read('input').each_line.map(&:chomp).map { |l| l.split("-") }
computers = connections.flatten.to_set
map = Hash.new { |h, k| h[k] = Set[] }
connections.each{ |a, b|
 map[a] << b
 map[b] << a
}

# Bron–Kerbosch
find_max_cliques = lambda { |r, p, x|
  if p.empty? && x.empty?
    [r]
  else
    p.reduce([[], p, x]) { |(memo, p2, x2), v|
      memo += find_max_cliques[r | Set[v], p2 & map[v], x2 & map[v]]
      [memo, p2 - Set[v], x2 | Set[v]]
    }.first
  end
}

puts find_max_cliques[Set[], computers, Set[]].sort_by(&:size).last.to_a.sort.join(",")
