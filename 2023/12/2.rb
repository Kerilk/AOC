input = File.read('input').each_line.map(&:split).map { |sources, counts| [sources, counts.split(',').map(&:to_i)] }

def match?(str, pattern)
  return false if str.size < pattern.size
  pattern.chars.each_with_index.all? { |c, i|
    str[i] == '?' || str[i] == c
  }
end

@memo = {}

def fits(str, list)
  @memo[[str, list]] ||= begin
    pattern = '#'*list.first
    pattern += '.' if list.size > 1
    str.size.times.filter_map { |i|
      pat = '.'*i + pattern
      pat += '.'*(str.size - pat.size) if list.size == 1 && pat.size < str.size
      if match?(str, pat)
        if list.size > 1
          fits(str[pat.size..-1], list[1..-1])
        else
          1
        end
      end
    }.sum
  end
end

p input.map { |str, list| fits(str, list) }.sum

input = input.map { |sources, counts| [sources + ('?' + sources)*4, counts*5] }
p input.map { |str, list| fits(str, list) }.sum
