rules, messages = File.read('input').split("\n\n")
$rules = rules.lines.collect! { |r|
  k, v = r.chomp.match(/(\d+): (.*)/)[1..2]
  k = k.to_i
  v = if v[0] == "\""
      v[1]
    elsif v.match "\\|"
      begin
        v.match(/(.*) \| (.*)/)[1..2].collect { |s|
          s.scan(/\d+/).collect(&:to_i).flatten
        }
      rescue
        p v
        raise
      end
    else
      [v.scan(/\d+/).flatten.collect(&:to_i)]
    end
  [k, v]
}.sort.to_h
$rules[8] = [[42], [42, 8]]
$rules[11] = [[42, 31], [42, 11, 31]]
messages = messages.each_line.collect(&:chomp)

def build_regexp(rule)
  case r = $rules[rule]
  when String
    r
  else
    expl = r.collect { |rs|
      rs.collect { |ri|
        build_regexp(ri)
      }.join
    }
    if expl.length > 1
      "(?:" << expl.join("|") << ")"
    else
      expl[0]
    end
  end
end

exp42 = build_regexp(42)
exp31 = build_regexp(31)
expr1 = /\A#{exp42}/
expr2 = /#{exp31}\z/
puts messages.count { |m|
  count1 = 0
  while r = m.match(expr1)
    count1 += 1
    m.delete_prefix!(r[0])
  end
  count2 = 0
  while r = m.match(expr2)
    count2 += 1
    m.delete_suffix!(r[0])
  end
  m == "" && count2 > 0 && count1 > count2
}
