secrets = File.read('input').each_line.map(&:to_i)

def next_secret(secret)
  secret ^= secret << 6
  secret &= 0xffffff
  secret ^= secret >> 5
  secret &= 0xffffff
  secret ^= secret << 11
  secret &= 0xffffff
end

p secrets.sum { |secret| 2000.times.inject(secret) { |memo, _| next_secret(memo) } }

sequences = secrets.map { |secret|
  prices = 2000.times.inject([secret]) { |memo, _|
    memo << next_secret(memo.last)
  }.map(&:digits).map(&:first)
  prices.each_cons(2).map { |a, b| b - a }.each_cons(4).zip(prices[4..-1]).reverse.to_h
}
p sequences.map(&:keys).map(&:to_set).reduce(:|).map { |pattern| sequences.filter_map { |s| s[pattern] }.sum }.max
