reports = File.read('input').each_line.map { |line| line.split.map(&:to_i) }
p reports.select { |levels|
  diffs = levels.each_cons(2).map { |a, b| b - a }
  diffs.map { |v| v <=> 0 }.uniq.count == 1 && diffs.all? { |v| (1..3).include? v.abs }
}.count
