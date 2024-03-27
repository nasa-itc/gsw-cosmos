require 'cosmos'
require 'cosmos/script'
require 'cosmos_cfs_config'

require 'cfs_lib.rb'

#
# Definitions
#


#
# Functions
#
def enable_TO_and_verify()
    cmd("CFS_RADIO TO_ENABLE_OUTPUT with DEST_IP 'radio_sim', DEST_PORT 5011")
    cmd("CFS_RADIO TO_RESUME_OUTPUT")
    wait_check_packet("CFS_RADIO", "CF_HKPACKET", 1, 5) 
end
