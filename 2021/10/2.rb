d = File.read("input").each_line.map(&:strip).map(&:chars)
tokens = { "(" => -1, ")" => 1, "[" => -2, "]" => 2, "{" => -3, "}" => 3, "<" => -4, ">" => 4 }

scores = d.map { |l|
  catch(:error) {
    stack = []
    l.each do |c|
      v = tokens[c]
      if v < 0
        stack.push(v)
      else
        throw :error, nil if stack.empty? || stack.last + v != 0
        stack.pop
      end
    end
    stack.reverse.reduce(0) { |memo, e| memo * 5 - e }
  }
}.compact.sort
p scores[scores.size/2]
