input = File.read('input').each_line.map(&:split).map { |sources, counts| [sources, counts.split(',').map(&:to_i)] }

def match?(str, pattern)
  return false if str.size < pattern.size
  pattern.chars.each_with_index.all? { |c, i|
    str[i] == '?' || str[i] == c
  }
end

def fits(str, list, res)
  pattern = '#'*list.first
  pattern += '.' if list.size > 1
  str.size.times.filter_map { |i|
    pat = '.'*i + pattern
    pat += '.'*(str.size - pat.size) if list.size == 1 && pat.size < str.size
    if match?(str, pat)
      if list.size > 1
        fits(str[pat.size..-1], list[1..-1], res + pat)
      else
        puts res + pat
        1
      end
    end
  }.sum
end

p input.map { |str, list| fits(str, list, '') }.sum
