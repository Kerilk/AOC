require 'narray'
require 'colorize'

def insert(output, list, node)
  (i, j), cost = node
  list.insert(list.bsearch_index { |_, c| c >= cost } || list.size, node)
  output[i, j] = -2
end

def costs(input)
  n, m = input.shape
  output = NArray.sint(n, m).fill!(-2)
  output[1..-2, 1..-2] = -1
  count = 0
  list = [[[1, 1], 0]]
  while !list.empty?
    (i, j), cost = list.shift
    output[i, j] = cost
    insert(output, list, [[i + 1, j], cost + input[i + 1, j]]) if output[i + 1, j] == -1
    insert(output, list, [[i - 1, j], cost + input[i - 1, j]]) if output[i - 1, j] == -1
    insert(output, list, [[i, j + 1], cost + input[i, j + 1]]) if output[i, j + 1] == -1
    insert(output, list, [[i, j - 1], cost + input[i, j - 1]]) if output[i, j - 1] == -1
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
  list = [[n-2, m-2]]
  while !list.empty?
    i, j = list.pop
    path[i, j] = 1
    score = output[i, j]
    v = []
    v.push output[i + 1, j] if (c = output[i + 1, j]) >= 0 && c < score
    v.push output[i - 1, j] if (c = output[i - 1, j]) >= 0 && c < score
    v.push output[i, j + 1] if (c = output[i, j + 1]) >= 0 && c < score
    v.push output[i, j - 1] if (c = output[i, j - 1]) >= 0 && c < score
    min = v.min
    insert_path(path, list, [i + 1, j]) if path[i + 1, j] == 0 && output[i + 1, j] == min
    insert_path(path, list, [i - 1, j]) if path[i - 1, j] == 0 && output[i - 1, j] == min
    insert_path(path, list, [i, j + 1]) if path[i, j + 1] == 0 && output[i, j + 1] == min
    insert_path(path, list, [i, j - 1]) if path[i, j - 1] == 0 && output[i, j - 1] == min
  end
  path
end

def print_with_paths(input, paths)
  n, m = input.shape
  pr = []
  (1..(m-2)).each { |j|
    a = []
    (1..(n-2)).each { |i|
      v = input[i, j].to_s
      v = v.blue if paths[i, j] == 1
      a.push v
    }
    pr.push a
  }
  puts pr.map(&:join).join("\n")
end

def replicate(x, y, input_base_data)
  n, m = input_base_data.shape
  input = NArray.byte(n * x + 2, m * y + 2)
  y.times do |j|
    x.times do |i|
      i0 = i * n + 1
      j0 = j * m + 1
      input_tmp = input_base_data + (i + j)
      m.times do |k|
        n.times do |l|
          input_tmp[k, l] -= 9 if input_tmp[k, l] > 9
        end
      end
      input[i0...(i0 + n), j0...(j0 + m)] = input_tmp
    end
  end
  input
end

d = File.read("input2").each_line.map(&:strip).map(&:chars)
input_base_data = NArray.to_na(d.flatten.map(&:to_i).pack("c*"), NArray::BYTE, d.first.size, d.size)
input_base = NArray.byte(input_base_data.shape[0] + 2, input_base_data.shape[1] + 2)
input_base[1..-2, 1..-2] = input_base_data
input = replicate(5, 5, input_base_data)

[input_base, input].each { |i|
  output = costs(i)
  paths = paths(output)
  print_with_paths(i, paths)
  p output[-2, -2]
}
