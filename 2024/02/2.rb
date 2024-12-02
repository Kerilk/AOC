reports = File.read('input').each_line.map { |line| line.split.map(&:to_i) }
valid = lambda { |levels|
  diffs = levels.each_cons(2).map { |a, b| b - a }
  diffs.map { |v| v <=> 0 }.uniq.count == 1 && diffs.all? { |v| (1..3).include? v.abs }
}
p reports.select { |levels|
  valid[levels] || (0...levels.size).any? { |i| valid[levels[0...i]+levels[(i+1)..-1]] }
}.count
