puts data = File.read("./input").lines.count { |s|
  _, first, second, char, chars = *s.match(/(\d+)-(\d+) (\w): (\w+)/)
  (chars[first.to_i-1] == char) ^ (chars[second.to_i-1] == char)
}
