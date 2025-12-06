ranges, ids = File.read('input').split("\n\n")
ranges = ranges.each_line.map { |l| Range.new(*l.split('-').map(&:to_i)) }
p ids.each_line.map(&:to_i).count { |id| ranges.any? { |r| r.include?(id) } }
