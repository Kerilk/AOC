positions = File.read("input").each_line.map { |l| l.match(/Player \d starting position: (\d)/)[1].to_i - 1 }
scores = [0, 0]

num_rolls = 0

$memo = {}

def roll(positions, scores, player, rolls)
  $memo[[positions, scores, player, rolls.sort]] ||= begin
    if rolls.length == 3
      p = positions.dup
      s = scores.dup
      p[player] = (p[player] + rolls.sum) % 10
      s[player] += p[player] + 1
      if s[player] >= 21
        player == 0 ? [1, 0] : [0, 1]
      else
        player ^= 1
        (1..3).map { |i| roll(p, s, player, [i]) }.reduce([0,0]) { |memo, v| [memo[0] + v[0], memo[1] + v[1]] }
      end
    else
      (1..3).map { |i| roll(positions, scores, player, rolls + [i]) }.reduce([0,0]) { |memo, v| [memo[0] + v[0], memo[1] + v[1]] }
    end
  end
end

p roll(positions, scores, 0, []).max
