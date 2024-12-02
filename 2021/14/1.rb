template, rules = File.read("input").split("\n\n")
p template
template = template.strip.chars
rules = rules.each_line.map { |l| l.match(/(\w\w) -> (\w)/)[1..2] }.map { |p, c| [p.chars, c ] }.to_h
polymer = template
10.times {
  new_polymer = []
  polymer.each_cons(2) { |pair|
    new_polymer << pair.first << rules[pair]
  }
  new_polymer << polymer.last
  polymer = new_polymer
  p polymer.join
}
p t.last[1] - t.first[1]
