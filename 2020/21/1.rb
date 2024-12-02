require 'set'

d = File.read('input').each_line.collect { |l|
  m = l.match(/(.*?) \(contains (.*?)\)/)
  [m[1].split(" ").to_set, m[2] ? m[2].split(", ").to_set : Set.new]
}
alergens = d.collect { |_, a| a}.reduce(:|)
ingredients = d.collect { |i, _| i}.reduce(:|)

candidates = alergens.collect { |a|
  [a, d.select { |_, as| as.include?(a) }.collect { |is, _| is }.reduce(:&)]
}.to_h

map = {}

while !candidates.empty?
  cs = candidates.select { |a, is| is.size == 1 }
  cs.each { |a, is|
    map[a] = is.to_a.first
    candidates.delete(a)
    candidates.each { |al, ins|
      ins.subtract(is)
    }
  }
end

non_allergens = ingredients - map.values
p non_allergens.sum { |i|
  d.count { |is, _|
    is.include?(i)
  }
}

p map.collect { |a, i| [a, i] }.sort.collect { |_, i| i }.join(",")
