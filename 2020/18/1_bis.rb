def tokenize(str)
  str.each_char.collect { |c|
    case c
    when " "
      nil
    when /\d/
      c.to_i
    else
      c
    end
  }.compact
end

def parse(tokens)
  precedence = { "*" => 1, "+" => 2 }
  operators = precedence.keys
  stack_op = []
  stack = []
  tokens.each { |t|
    case t
    when Integer
      stack.push(t)
    when *operators
      while stack_op.last && (stack_op.last != "(" && precedence[stack_op.last] >= precedence[t])
        stack.push stack_op.pop
      end
      stack_op.push t
    when "("
      stack_op.push t
    when ")"
      while stack_op.last && stack_op.last != "("
        stack.push stack_op.pop
      end
      stack_op.pop
    end
  }
  while !stack_op.empty?
    stack.push stack_op.pop
  end
  stack
end

def seval(stack)
  case op = stack.pop
  when Integer
    op
  when "+"
    seval(stack) + seval(stack)
  when "*"
    seval(stack) * seval(stack)
  end
end

puts File.read('input').each_line.sum { |l|
  seval(parse(tokenize(l)))
}
