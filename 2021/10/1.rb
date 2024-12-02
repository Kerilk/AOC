d = File.read("input").each_line.map(&:strip).map(&:chars)
tokens = { "(" => -3, ")" => 3, "[" => -57, "]" => 57, "{" => -1197, "}" => 1197, "<" => -25137, ">" => 25137 }

p d.map { |l|
  catch(:error) {
    stack = []
    l.each do |c|
      v = tokens[c]
      if v < 0
        stack.push(v)
      else
        throw :error, v if stack.empty? || stack.last + v != 0
        stack.pop
      end
    end
    0
  }
}.sum
