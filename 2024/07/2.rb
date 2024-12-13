equations = File.read('input').each_line.map { |l|
  l.split(':').yield_self { |val, list|
    [val.to_i, list.split.map(&:to_i)]
  }
}

def search(v, sub, *l)
  n = l.shift
  cand = [sub + n, sub * n, (sub.to_s + n.to_s).to_i]
  if l.empty?
    throw :found, true if cand.include?(v)
  else
    cand.each { |i| search(v, i, *l) }
  end
  false
end

def check(v, l)
  catch(:found) do
    search(v, *l)
  end
end

p equations.filter { |v, l| check(v, l) }.sum { |v, _| v }
