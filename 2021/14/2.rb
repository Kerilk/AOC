require 'date'
template, rules = File.read("input").split("\n\n")
template = template.strip
$rules = rules.each_line.map { |l| l.match(/(\w\w) -> (\w)/)[1..2] }.map { |p, c| [p.chars, c ] }.to_h

$cache = {}

def recurse(pattern, depth = 40)
  $cache[[pattern, depth]] ||= 
    if depth == 0
      pattern.chars.tally
    else
      new_pattern = ""
      pattern.each_char.each_cons(2) { |pair|
        new_pattern << pair.first << $rules[pair]
      }
      new_pattern << pattern[-1]
      pattern_tally = new_pattern.chars[1..-2].tally
      tallys = new_pattern.each_char.each_cons(2).map { |pair|
        recurse(pair.join, depth - 1)
      }
      t = tallys.first.merge(*tallys[1..-1]) { |k, v1, v2| v1 + v2 }
      t.merge(pattern_tally) { |k, v1, v2| v1 - v2 }
    end
end
t = recurse(template, 40).sort_by { |_, v| v }
p t.last[1] - t.first[1]
