require 'matrix'
p File.read("input").each_line.collect(&:split).reduce(Vector[0, 0]) { |memo, (dir, amount)|
  a = amount.to_i
  case dir
  when "forward"
    memo + Vector[a, 0]
  when "down"
    memo + Vector[0, a]
  when "up"
    memo + Vector[0, -a]
  end
}.reduce(:*)
