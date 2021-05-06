require 'cosmos/conversions/conversion'
require 'utilities'

module Cosmos
  class OrbitNormal < Conversion
    def initialize(*args)
      super()
      @items = args
      @converted_type = :FLOAT
      @converted_bit_size = 64
      @converted_array_size = 3
    end

    def call(value, packet, buffer)
      p = packet.read(@items[0])
      v = packet.read(@items[1])

      pxv = Utilities::cross(p,v)
      orbnorm = Utilities::sxv(1/Utilities::norm(pxv), pxv)

      return orbnorm
    end

  end
end