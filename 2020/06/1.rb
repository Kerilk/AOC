puts File.read("input").split("\n\n").collect { |block|
  block.split("\n").collect(&:chars).reduce(:+).uniq.count
}.reduce(:+)

