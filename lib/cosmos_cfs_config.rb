# -*- coding: utf-8 -*-
require "cosmos_cfs_config/version"

module CosmosCfsConfig
    PROCESSOR_ENDIAN = ENV.fetch('PROCESSOR_ENDIANNESS', 'LITTLE_ENDIAN')
end
