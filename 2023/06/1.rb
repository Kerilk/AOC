times, distances = File.read('input').each_line.map { |l| l.scan(/\d+/).map(&:to_i) }
p times.zip(distances).map { |time, distance|
  time.times.map { |i| i * (time - i) }.select { |d| d > distance }.count
}.reduce(:*)
