require 'cosmos/conversions/conversion'

module Cosmos
  class BetaAngle < Conversion
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
      svb = packet.read(@items[2])
      qbn = packet.read(@items[3])

      pxv = Utilities::cross(p,v)
      orbnorm = Utilities::sxv(1/Utilities::norm(pxv), pxv)
      cbn = Utilities::Q2C(qbn)
      svn = Utilities::MTxV(cbn,svb)

      beta = 90.0 - 180.0*Math.acos(Utilities::dot(orbnorm,svn))/Math::PI

      return beta
    end

  end
end