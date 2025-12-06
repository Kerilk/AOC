p File.read('input').tr('L','-').tr('R','').each_line.map(&:to_i).reduce([50]) { |memo, shift| memo << (memo.last + shift) % 100 }.count(0)
