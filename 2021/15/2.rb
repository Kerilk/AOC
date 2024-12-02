require 'narray'
require 'colorize'

def bsearch(list, cost)
  low = 0
  high = list.size - 1
  while low <= high do
    split = (low+high) / 2
    if list[split][1] > cost
      high = split - 1
    else
      low = split + 1
    end
  end
  return low
end

def insert(output, list, node)
  list.insert(bsearch(list, node[1]), node)
  output[*node[0]] = -2
end

def costs(input)
  n, m = input.shape
  output = NArray.sint(n, m)
  output[0..-1, 0..-1] = -1
  count = 0
  list = [[[0, 0], 0]]
  while !list.empty?
    node = list.shift
    i, j = node[0]
    cost = node[1]
    output[i, j] = cost
    insert(output, list, [[i + 1, j], cost + input[i + 1, j]]) if i < n - 1 && output[i + 1, j] == -1
    insert(output, list, [[i - 1, j], cost + input[i - 1, j]]) if i > 0 && output[i - 1, j] == -1
    insert(output, list, [[i, j + 1], cost + input[i, j + 1]]) if j < m - 1 && output[i, j + 1] == -1
    insert(output, list, [[i, j - 1], cost + input[i, j - 1]]) if j > 0 && output[i, j - 1] == -1
  end
  output
end

def insert_path(path, list, node)
  list << node
  path[*node] = 2
end

def paths(output)
  n, m = output.shape
  path = NArray.byte(n, m)
  list = [[n-1, m-1]]
  while !list.empty?
    i, j = list.pop
    path[i, j] = 1
    v = []
    v.push output[i + 1, j] if i < n - 1 && output[i + 1, j] < output[i, j]
    v.push output[i - 1, j] if i > 0 && output[i - 1, j] < output[i, j]
    v.push output[i, j + 1] if j < m - 1 && output[i, j + 1] < output[i, j]
    v.push output[i, j - 1] if j > 0 && output[i, j - 1] < output[i, j]
    min = v.min
    insert_path(path, list, [i + 1, j]) if i < n - 1 && path[i + 1, j] == 0 && output[i + 1, j] == min
    insert_path(path, list, [i - 1, j]) if i > 0 && path[i - 1, j] == 0 && output[i - 1, j] == min
    insert_path(path, list, [i, j + 1]) if j < m - 1 && path[i, j + 1] == 0 && output[i, j + 1] == min
    insert_path(path, list, [i, j - 1]) if j > 0 && path[i, j - 1] == 0 && output[i, j - 1] == min
  end
  path
end

def print_with_paths(input, paths)
  n, m = input.shape
  pr = input.to_a
  m.times { |j|
    n.times { |i|
      pr[j][i] = input[i, j].to_s
      pr[j][i] = pr[j][i].blue if paths[i, j] == 1
    }
  }
  puts pr.map(&:join).join("\n")
end

d = File.read("input").each_line.map(&:strip).map(&:chars)
input_base = NArray.to_na(d.flatten.map(&:to_i).pack("c*"), NArray::BYTE, d.first.size, d.size)
input = NArray.byte(d.first.size*5, d.size*5)
5.times { |j|
  5.times { |i|
    i0 = i * d.first.size
    j0 = j * d.size
    input_tmp = input_base + (i + j)
    d.size.times { |k|
      d.first.size.times { |l|
        input_tmp[k, l] -= 9 if input_tmp[k, l] > 9
      }
    }
    input[i0...(i0 + d.first.size), j0...(j0 + d.size)] = input_tmp
  }
}

[input_base, input].each { |i|
  output = costs(i)
  paths = paths(output)
  print_with_paths(i, paths)
  p output[-1, -1]
}
