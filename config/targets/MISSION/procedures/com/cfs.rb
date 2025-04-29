require 'cosmos'
require 'cosmos/script'
require 'cfs_lib.rb'

##
## This script tests the standard cFS application aliveness.
##

# CCSDS File Delivery Protocol (CF)
CFS_TEST_LOOP_COUNT.times do |n|
    get_cf_hk()
    cf_cmd("CFS CF_NOOP")
end

# Data Storage (DS)
CFS_TEST_LOOP_COUNT.times do |n|
    get_ds_hk()
    ds_cmd("CFS DS_NOOP")
end

# File Manager (FM)
CFS_TEST_LOOP_COUNT.times do |n|
    get_fm_hk()
    fm_cmd("CFS FM_NOOP")
end

# Limit Checker (LC)
CFS_TEST_LOOP_COUNT.times do |n|
    get_lc_hk()
    lc_cmd("CFS LC_NOOP")
end

# Stored Commands (SC)
CFS_TEST_LOOP_COUNT.times do |n|
    get_sc_hk()
    sc_cmd("CFS SC_NOOP")
end
