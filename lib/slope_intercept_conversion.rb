require 'cosmos/conversions/conversion'

module Cosmos
  class SlopeInterceptConversion < Conversion
    def initialize(packet_field, slope, intercept=0)
      super()
      @converted_type = :FLOAT
      @converted_bit_size = 32
      @packet_field = packet_field
      @slope = slope.to_f
      @intercept = intercept.to_f
    end
    def call(value, packet, buffer)
      v =  * 2.50/1024
      # Slope
      value = @slope * packet.read(@packet_field)
      # Intercept
      value = value + @intercept
      return value
    end
  end
end
