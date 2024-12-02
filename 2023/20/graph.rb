require 'graphviz'

modules = File.read('input').each_line.map(&:strip).map { |l|
  mod, outputs = l.split(' -> ')
  outputs = outputs.split(', ')
  name, type, state = case mod
    when "broadcaster"
      [mod, :broadcaster, nil]
    when /%(\w+)/
      [$~[1], :flipflop, false]
    when /&(\w+)/
      [$~[1], :conjunction, {}]
    end
  [name, {type: type, outputs: outputs, state: state}]
}.to_h
modules.default = { type: :none, outputs: [] }

modules["button"] = {type: :button, outputs: ["broadcaster"]}
modules.each { |k, v|
  v[:outputs].each { |output|
    if modules[output][:type] == :conjunction
      modules[output][:state][k] = false
    end
  }
}
modules["rx"] = modules["rx"]

g = GraphViz::new( :G, :type => :digraph )

nodes = modules.each.map { |k, v|
  str = (v[:type] == :flipflop ? "%" : v[:type] == :conjunction ? "&" : "") + k
  p str
  n = g.add_nodes(str)
  [k, n]
}.to_h
nodes.each { |k, n|
  modules[k][:outputs].each { |output|
    g.add_edges(n, nodes[output])
  }
}

File.open("output.png", "wb") { |f|
  f.write g.output( png: String )
}
