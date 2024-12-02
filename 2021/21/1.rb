positions = File.read("input").each_line.map { |l| l.match(/Player \d starting position: (\d)/)[1].to_i - 1 }
scores = [0, 0]

deterministic_dice = (1..100).cycle

num_rolls = 0
winner = nil
2.times.cycle { |i|
  rolls = 3.times.map { deterministic_dice.next }.sum
  num_rolls += 3
  positions[i] = (positions[i] + rolls) % 10
  scores[i] += positions[i] + 1
  if scores[i] >= 1000
    winner = i
    break
  end
}
p scores[winner ^ 1] * num_rolls
