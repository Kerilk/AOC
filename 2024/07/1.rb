equations = File.read('input').each_line.map { |l|
  l.split(':').yield_self { |val, list|
    [val.to_i, list.split(' ').map(&:to_i)]
  }
}

def compute(v, sub, *l)
  sum = sub + l.first
  prod = sub * l.first
  if l.size == 1
    throw :found, true if v == sum || v == prod
  else
    compute(v, sum, *l[1..-1])
    compute(v, prod, *l[1..-1])
  end
  false
end

def check(v, l)
  catch(:found) do
    compute(v, *l)
  end
end

p equations.filter { |v, l|
  check(v, l)
}.sum { |v, _| v }
