require 'date'
template, rules = File.read("input").split("\n\n")
template = template.strip.chars
$rules = rules.each_line.map { |l| l.match(/(\w\w) -> (\w)/)[1..2] }.map { |p, c| [p.chars, c ] }.to_h
$cache = {}

def recurse(pattern, depth)
  $cache[[pattern, depth]] ||= 
    if depth == 0
      { pattern[0] => 1 }
    else
      if pattern.length == 2
        pattern = [pattern[0], $rules[pattern], pattern[1]]
        depth -= 1
      end
      pattern.each_cons(2).map { |pair|
        recurse(pair, depth)
      }.reduce { |memo, tally| memo.merge(tally) { |k, v1, v2| v1 + v2 } }
    end
end
t = recurse(template, 40)
t[template.last] += 1
t = t.sort_by { |_, v| v }
p t.last[1] - t.first[1]
