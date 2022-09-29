# Send the cFS TO_ENABLE command
require 'cosmos'
require 'cosmos/script'

# Send the command
cmd("CFS TO_ENABLE_OUTPUT with DEST_IP '127.0.0.1', DEST_PORT 5011")

# Use CFE_ES_HKPACKET as benchmark to verify its enabled
wait_packet("CFS", "CFE_ES_HKPACKET", 3, 15)

