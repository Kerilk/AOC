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

modules.default = { type: :none }
modules["button"] = {type: :button, outputs: ["broadcaster"]}

modules.each { |k, v|
  v[:outputs].each { |output|
    if modules[output][:type] == :conjunction
      modules[output][:state][k] = false
    end
  }
}

queue = []
counts = Hash.new { |h, k| h[k] = 0 }
button = 0

send = lambda { |source, dest, pulse|
  #puts "#{source} -#{pulse ? "high" : "low"}-> #{dest}"
  counts[pulse] += 1
  queue.push [source, dest, pulse]
}

actions = {
  button: lambda {
    button += 1
    send["button", "broadcaster", false]
  },
  broadcaster: lambda { |signal|
    _, dest, pulse = signal
    modules[dest][:outputs].each { |output| send["broadcaster", output, pulse] }
  },
  flipflop: lambda { |signal|
    _, dest, pulse = signal
    if !pulse
      modules[dest][:state] = !modules[dest][:state]
      modules[dest][:outputs].each { |output| send[dest, output, modules[dest][:state]] }
    end
  },
  conjunction: lambda { |signal|
    source, dest, pulse = signal
    state = modules[dest][:state]
    state[source] = pulse
    modules[dest][:outputs].each { |output| send[dest, output, !state.values.all?(true)] }
  },
  none: lambda { |signal| }
}

button_press = lambda {
  actions[:button].call
  while (signal = queue.shift)
    source, dest, pulse = signal
    actions[modules[dest][:type]][signal]
  end
}

1000.times {
  button_press.call
}
p counts.values.reduce(:*)

modules.each_value { |v|
  case v[:type]
  when :flipflop
    v[:state] = false
  when :conjunction
    v[:state].transform_values! { |_| false }
  end
}
counts.transform_values! { |_| 0 }
button = 0

parent, _ = modules.find { |k, v|
  v[:outputs].include?('rx')
}
grandparents_count = modules.find_all { |k, v|
  v[:outputs].include?(parent)
}.count

buttons = {}

send = lambda { |source, dest, pulse|
  counts[pulse] += 1
  buttons[source] = button if dest == parent && pulse
  throw :finished if buttons.size == grandparents_count
  queue.push [source, dest, pulse]
}

catch(:finished) do
  loop do
    button_press.call
  end
end
p buttons
p buttons.values.reduce(:*)
