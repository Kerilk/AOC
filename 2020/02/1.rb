puts File.read("./input").lines.count { |s|
  _, start, stop, char, chars = *s.match(/(\d+)-(\d+) (\w): (\w+)/)
  chars.count(char).between?(start.to_i, stop.to_i)
}
