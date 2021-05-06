require 'cosmos/conversions/conversion'
require 'utilities'

module Cosmos
  class Svn < Conversion
    def initialize(*args)
      super()
      @items = args
      @converted_type = :FLOAT
      @converted_bit_size = 64
      @converted_array_size = 3
    end

    def call(value, packet, buffer)
      svb = packet.read(@items[0])
      qbn = packet.read(@items[1])
      cbn = Utilities::Q2C(qbn)
      svn = Utilities::MTxV(cbn,svb)
      return svn
    end

  end
end