workflows, parts = File.read('input').split("\n\n").yield_self { |wfs, pts|
  [
    wfs.each_line.map { |l| l.match(/(\w+){(.*)}/)[1..2] }.map { |label, rules|
      [
        label, rules.split(',').map { |rule|
          res = rule.split(':')
          res.unshift 'true' if res.size == 1
          res
        }
      ] }.to_h,
    pts.each_line.map { |l| l.scan(/\d+/).map(&:to_i) }
  ]
}
p parts.filter { |x, m, a, s|
  state = 'in'
  while !['A', 'R'].include?(state)
    state = workflows[state].each { |cond, label| break label if eval(cond) }
  end
  state == 'A'
}.map(&:sum).sum

results = []
candidates = [[1..4000, 1..4000, 1..4000, 1..4000, 'in', 0]]
while !candidates.empty?
  candidate = candidates.pop
  x, m, a, s, state, step = candidate
  if ['A', 'R'].include?(state)
    results.push candidate
    next
  end
  cond, label = workflows[state][step]
  if cond == 'true'
    candidates.push [x, m, a, s, label, 0]
  else
    var, op, val = cond.match(/(x|m|a|s)(<|>)(\d+)/)[1..3]
    val = val.to_i
    low_range = eval(var).begin..(val - (op == '<' ? 1 : 0))
    high_range = (low_range.end + 1)..eval(var).end
    eval("#{var} = #{op =='<' ? low_range : high_range}")
    candidates.push [x, m, a, s, label, 0]
    eval("#{var} = #{op =='<' ? high_range : low_range}")
    candidates.push [x, m, a, s, state, step+1]
  end
end
p results.select { |_ , _, _, _, state, _| state == 'A' }.map { |x, m, a, s, _, _| [x, m, a, s].map(&:size).reduce(&:*) }.sum
