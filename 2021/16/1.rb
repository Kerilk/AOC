class Packet
  attr_reader :version, :type_id
  def initialize(bitstream, version, type_id)
    @bitstream = bitstream
    @version = version
    @type_id = type_id
  end

  def self.parse(bitstream)
    v = bitstream.get(3)
    t = bitstream.get(3)
    case t
    when 4
      ImmediatePacket.new(bitstream, v, t)
    else
      OperatorPacket.new(bitstream, v, t)
    end
  end

  def version_sum
    @version
  end
end

class ImmediatePacket < Packet
  attr_reader :value
  def initialize(bitstream, version, type_id)
    super
    @value = ImmediatePacket.value(bitstream)
  end

  def self.value(bitstream)
    v = 0
    loop do
      v <<= 4
      c = bitstream.get(5)
      v |= c & 0xf
      return v unless (c & 0x10) != 0
    end
  end

end

class OperatorPacket < Packet
  attr_reader :length_type
  attr_reader :sub_packets
  def initialize(bitstream, version, type_id)
    super
    @length_type = bitstream.get(1)
    @sub_packets = []
    if @length_type == 0
      @length = bitstream.get(15)
      r = bitstream.remaining_bits
      while r - bitstream.remaining_bits < @length
        @sub_packets.push Packet.parse(bitstream)
      end
    else
      @packet_number = bitstream.get(11)
      @packet_number.times {
        @sub_packets.push Packet.parse(bitstream)
      }
    end
  end

  def version_sum
    super + @sub_packets.map(&:version_sum).sum
  end

  def value
    case @type_id
    when 0
      @sub_packets.map(&:value).sum
    when 1
      @sub_packets.map(&:value).reduce(:*)
    when 2
      @sub_packets.map(&:value).min
    when 3
      @sub_packets.map(&:value).max
    when 5
      @sub_packets[0].value > @sub_packets[1].value ? 1 : 0
    when 6
      @sub_packets[0].value < @sub_packets[1].value ? 1 : 0
    when 7
      @sub_packets[0].value == @sub_packets[1].value ? 1 : 0
    else
      raise "unknown packet type #{@type_id}"
    end
  end
end

class BitStream
  attr_reader :remaining_bits
  def initialize(message)
    @v = 0
    @bits = 0
    @message = message.chars
    @remaining_bits = @message.size * 4
  end

  def get(n)
    raise "Insufficient bits remaining" if @remaining_bits < n
    while @bits < n
      @v <<= 4
      @v |= @message.shift.to_i(16)
      @bits += 4
    end
    mask = ((1 << n) - 1) << (@bits - n)
    b = @v & mask
    @v ^= b
    b >>= (@bits - n)
    @bits -= n
    @remaining_bits -= n
    b
  end
end

hex_string = File.read("input").strip
bs = BitStream.new(hex_string)

packet = Packet.parse(bs)
p packet.version_sum
p packet.value
