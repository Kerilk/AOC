time, distance = File.read('input').each_line.map { |l| l.gsub(' ','').match(/\d+/)[0].to_i }
det = Math.sqrt(time * time - 4 * distance).floor
p det.floor
p (0.5*(time + det)).floor - (0.5*(time - det)).ceil + 1
