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
    cmd("CFS_RADIO TO_ENABLE_OUTPUT with DEST_IP 'radio-sim', DEST_PORT 5011")
    cmd("CFS_RADIO TO_RESUME_OUTPUT")
    wait_check_packet("CFS_RADIO", "CF_HKPACKET", 1, 5) 
end

def obtain_file_list_cam()
    filename = "/tmp/dirfilelist.txt"
    directory_list = [
        # Uncomment lines to get more files in listing
        # "/verified_overlay/",
        # "/verified_overlay/cf/",
        #"/update_scratch/",
        #"/update_scratch/cf/",
        #"/data/hk/",
        "/data/cam/"
    ]
    file_handle = File.open(filename, "w")
    for downlink_dir in directory_list
        dirlist_offset = 0
        loop do
          fm_cmd("CFS_RADIO FM_GET_DIR_PKT with DIRECTORY '#{downlink_dir}', DIRLISTOFFSET #{dirlist_offset}, GETSIZETIMEMODE 1")
          first_file = tlm("CFS_RADIO FM_DIRLISTPKT FIRSTFILE")
          packet_files = tlm("CFS_RADIO FM_DIRLISTPKT PACKETFILES")
          total_files = tlm("CFS_RADIO FM_DIRLISTPKT TOTALFILES")
          (1..packet_files).each do |num|
            puts "Found file: #{downlink_dir}" + tlm("CFS_RADIO FM_DIRLISTPKT FILENAME#{num}")
            file_handle.write "#{downlink_dir}" + tlm("CFS_RADIO FM_DIRLISTPKT FILENAME#{num}") + "\n"
          end
          dirlist_offset = dirlist_offset + packet_files
          break if (first_file + packet_files) >= total_files
        end
    end
    file_handle.close()
end
