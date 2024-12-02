require 'set'
d = File.read("input").each_line.map { |l| l.match(/([A-z]+)-([A-z]+)/) }.map { |m| m[1..2] }
graph = Hash.new { |h, k| h[k] = Set.new }
d.each do |n1, n2|
  n1, n2 = n2, n1 if n2 == "start" || n1 == "end"
  graph[n1].add n2
  graph[n2].add n1 if n1 != "start" && n2 != "end"
end
paths = [["start"]]
finished_paths = []
while !paths.empty?
  new_paths = []
  paths.each do |path|
    graph[path.last].each do |n|
      if n == "end"
        finished_paths.push(path + [n])
      else
        new_paths.push(path + [n]) unless n.match(/[a-z]/) && path.include?(n)
      end
    end
  end
  paths = new_paths
end
p finished_paths.size
