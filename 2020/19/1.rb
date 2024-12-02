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

expr = /\A#{build_regexp(0)}\z/
puts messages.count { |m|
  m.match(expr)
}
