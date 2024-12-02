require 'matrix'
p File.read("input").each_line.collect(&:split).reduce([0, Vector[0, 0]]) { |memo, (dir, amount)|
  a = amount.to_i
  case dir
  when "forward"
    memo[1] += Vector[a, memo[0]*a]
  when "down"
    memo[0] += a
  when "up"
    memo[0] -= a
  end
  memo
}[1].reduce(:*)
