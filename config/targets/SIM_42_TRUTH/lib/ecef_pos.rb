require 'cosmos/conversions/conversion'

module Cosmos
  class EcefPos < Conversion
    def initialize(*args)
      super()
      @items = args
      @converted_type = :FLOAT
      @converted_bit_size = 64
      @converted_array_size = 3
    end

    def call(value, packet, buffer)
      p   = [packet.read(@items[0]), packet.read(@items[1]), packet.read(@items[2])]
      qbn = [packet.read(@items[3]), packet.read(@items[4]), packet.read(@items[5]), packet.read(@items[6])]

      cbn = Utilities::Q2C(qbn)

      p_ecef = Utilities::MxV(cbn, p) # ECEF_POS Position Vector relative to Earth Fixed Frame

      return p_ecef
    end

  end
end