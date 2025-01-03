connections = File.read('input').each_line.map(&:chomp).map { |l| l.split("-") }
computers = connections.flatten.to_set
map = Hash.new { |h, k| h[k] = [] }
connections.each{ |a, b|
 map[a] << b
 map[b] << a
}
candidates = computers.select { |c| c.start_with?('t') }
p computers.to_a.combination(3).filter { |a, b, c|
  map[a].include?(b) && map[a].include?(c) && map[b].include?(c) && [a, b, c].any? { |comp| candidates.include?(comp) }
}.size
