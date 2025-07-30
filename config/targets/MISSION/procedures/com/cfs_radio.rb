require 'cosmos'
require 'cosmos/script'
require 'cfs_lib_radio.rb'

##
## This script tests the standard cFS application aliveness.
## Specifically using the radio interface instead of debug.
##

# CCSDS File Delivery Protocol (CF)
CFS_RADIO_TEST_LOOP_COUNT.times do |n|
    get_cf_hk_radio()
    cf_cmd_radio("CFS_RADIO CF_NOOP")
end

# Data Storage (DS)
CFS_RADIO_TEST_LOOP_COUNT.times do |n|
    get_ds_hk_radio()
    ds_cmd_radio("CFS_RADIO DS_NOOP")
end

# File Manager (FM)
CFS_RADIO_TEST_LOOP_COUNT.times do |n|
    get_fm_hk_radio()
    fm_cmd_radio("CFS_RADIO FM_NOOP")
end

# Limit Checker (LC)
CFS_RADIO_TEST_LOOP_COUNT.times do |n|
    get_lc_hk_radio()
    lc_cmd_radio("CFS_RADIO LC_NOOP")
end

# Stored Commands (SC)
CFS_RADIO_TEST_LOOP_COUNT.times do |n|
    get_sc_hk_radio()
    sc_cmd_radio("CFS_RADIO SC_NOOP")
end
