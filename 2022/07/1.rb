class Directory < Hash
  attr_accessor :parent

  def initialize(parent)
    @parent = parent
  end

  def bytesize
    @bytesize ||= each_value.map { |e| e.is_a?(Directory) ? e.bytesize : e }.reduce(:+)
  end

  def each_dir(&block)
    return to_enum(:each_dir) unless block_given?
    each_value { |e| e.each_dir(&block) if e.is_a?(Directory) }
    yield self
    self
  end
end

fs = {"/" => Directory.new(nil)}
cur_dir = fs
File.foreach("input").map { |l|
  l.match(/\$ cd (.*)$|\$ ls|dir (.*)$|(\d+) (.*)/)
}.map(&:captures).each { |cd, dir, s, f|
  if cd
    cur_dir = cd == ".." ? cur_dir.parent : cur_dir[cd]
  elsif dir
    cur_dir[dir] = Directory.new(cur_dir)
  elsif s
    cur_dir[f] = s.to_i
  end
}
p fs["/"].each_dir.map(&:bytesize).filter { |e| e <= 100000 }.reduce(:+)
unused = 70000000 - fs["/"].bytesize
missing = 30000000 - unused
p fs["/"].each_dir.map(&:bytesize).sort.find { |e| e >= missing }
