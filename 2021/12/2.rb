require 'set'
d = File.read("input").each_line.map { |l| l.match(/([A-z]+)-([A-z]+)/) }.map { |m| m[1..2] }
graph = Hash.new { |h, k| h[k] = Set.new }
d.each do |n1, n2|
  n1, n2 = n2, n1 if n2 == "start" || n1 == "end"
  graph[n1].add n2
  graph[n2].add n1 if n1 != "start" && n2 != "end"
end
paths = [[["start"], false]]
finished_paths = 0
while !paths.empty?
  new_paths = []
  paths.each do |path, double|
    graph[path.last].each do |n|
      if n == "end"
        finished_paths += 1
      else
        if n == n.downcase && path.include?(n)
          new_paths.push([path + [n], true]) unless double
        else
          new_paths.push([path + [n], double])
        end
      end
    end
  end
  paths = new_paths
end
p finished_paths
