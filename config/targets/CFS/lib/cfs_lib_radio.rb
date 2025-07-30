require 'cosmos'
require 'cosmos/script'

#
# Definitions
#
CFS_RADIO_CMD_SLEEP = 0.25
CFS_RADIO_RESPONSE_TIMEOUT = 5
CFS_RADIO_TEST_LOOP_COUNT = 1


#
# CCSDS File Delivery Protocol (CF) Radio
#
def get_cf_hk_radio()
    cmd("CFS_RADIO CF_SEND_HK")
    wait_check_packet("CFS_RADIO", "CF_HKPACKET", 1, CFS_RADIO_RESPONSE_TIMEOUT)
end

def cf_cmd_radio(*command)
    count = tlm("CFS_RADIO CF_HKPACKET CMDCOUNTER") + 1

    if (count == 256)
        count = 0
    end

    cmd *command
    sleep(CFS_RADIO_CMD_SLEEP)
    get_cf_hk_radio()
    current = tlm("CFS_RADIO CF_HKPACKET CMDCOUNTER")
    if (current != count)
        # Try again
        cmd *command
        sleep(CFS_RADIO_CMD_SLEEP)
        get_cf_hk_radio()
        current = tlm("CFS_RADIO CF_HKPACKET CMDCOUNTER")
        if (current != count)
            # Third times the charm
            cmd *command
            sleep(CFS_RADIO_CMD_SLEEP)
            get_cf_hk_radio()
            current = tlm("CFS_RADIO CF_HKPACKET CMDCOUNTER")
        end
    end
    check("CFS_RADIO CF_HKPACKET CMDCOUNTER >= #{count}")
end

#
# Data Storage (DS) Radio
#
def get_ds_hk_radio()
    cmd("CFS_RADIO DS_SEND_HK")
    wait_check_packet("CFS_RADIO", "DS_HKPACKET", 1, CFS_RADIO_RESPONSE_TIMEOUT)
end

def ds_cmd_radio(*command)
    count = tlm("CFS_RADIO DS_HKPACKET CMDACCEPTEDCOUNTER") + 1

    if (count == 256)
        count = 0
    end

    cmd *command
    sleep(CFS_RADIO_CMD_SLEEP)
    get_ds_hk_radio()
    current = tlm("CFS_RADIO DS_HKPACKET CMDACCEPTEDCOUNTER")
    if (current != count)
        # Try again
        cmd *command
        sleep(CFS_RADIO_CMD_SLEEP)
        get_ds_hk_radio()
        current = tlm("CFS_RADIO DS_HKPACKET CMDACCEPTEDCOUNTER")
        if (current != count)
            # Third times the charm
            cmd *command
            sleep(CFS_RADIO_CMD_SLEEP)
            get_ds_hk_radio()
            current = tlm("CFS_RADIO DS_HKPACKET CMDACCEPTEDCOUNTER")
        end
    end
    check("CFS_RADIO DS_HKPACKET CMDACCEPTEDCOUNTER >= #{count}")
end

#
# File Manager (FM) Radio
#
def get_fm_hk_radio()
    cmd("CFS_RADIO FM_SEND_HK")
    wait_check_packet("CFS_RADIO", "FM_HOUSEKEEPINGPKT", 1, CFS_RADIO_RESPONSE_TIMEOUT)
end

def fm_cmd_radio(*command)
    count = tlm("CFS_RADIO FM_HOUSEKEEPINGPKT COMMANDCOUNTER") + 1

    if (count == 256)
        count = 0
    end

    cmd *command
    sleep(CFS_RADIO_CMD_SLEEP)
    get_fm_hk_radio()
    current = tlm("CFS_RADIO FM_HOUSEKEEPINGPKT COMMANDCOUNTER")
    if (current != count)
        # Try again
        cmd *command
        sleep(CFS_RADIO_CMD_SLEEP)
        get_fm_hk_radio()
        current = tlm("CFS_RADIO FM_HOUSEKEEPINGPKT COMMANDCOUNTER")
        if (current != count)
            # Third times the charm
            cmd *command
            sleep(CFS_RADIO_CMD_SLEEP)
            get_fm_hk_radio()
            current = tlm("CFS_RADIO FM_HOUSEKEEPINGPKT COMMANDCOUNTER")
        end
    end
    check("CFS FM_HOUSEKEEPINGPKT COMMANDCOUNTER >= #{count}")
end

def get_fm_files_radio(directory, offset)
    cmd("CFS_RADIO FM_GET_DIR_PKT with DIRECTORY '#{directory}', DIRLISTOFFSET #{offset}, GETSIZETIMEMODE 0xFFFFFFFF")
    wait_check_packet("CFS_RADIO", "FM_DIRLISTPKT", 1, CFS_RADIO_RESPONSE_TIMEOUT)
end

#
# Limit Checker (LC) Radio
#
def get_lc_hk_radio()
    cmd("CFS_RADIO LC_SEND_HK")
    wait_check_packet("CFS_RADIO", "LC_HKPACKET", 1, CFS_RESPONSE_TIMEOUT)
end

def lc_cmd_radio(*command)
    count = tlm("CFS_RADIO LC_HKPACKET CMDCOUNT") + 1

    if (count == 256)
        count = 0
    end

    cmd *command
    sleep(CFS_RADIO_CMD_SLEEP)
    get_lc_hk_radio()
    current = tlm("CFS_RADIO LC_HKPACKET CMDCOUNT")
    if (current != count)
        # Try again
        cmd *command
        sleep(CFS_RADIO_CMD_SLEEP)
        get_lc_hk_radio()
        current = tlm("CFS_RADIO LC_HKPACKET CMDCOUNT")
        if (current != count)
            # Third times the charm
            cmd *command
            sleep(CFS_RADIO_CMD_SLEEP)
            get_lc_hk_radio()
            current = tlm("CFS_RADIO LC_HKPACKET CMDCOUNT")
        end
    end
    check("CFS_RADIO LC_HKPACKET CMDCOUNT >= #{count}")
end

#
# Stored Commands (SC) Radio
#
def get_sc_hk_radio()
    cmd("CFS_RADIO SC_SEND_HK")
    wait_check_packet("CFS_RADIO", "SC_HKTLM", 1, CFS_RADIO_RESPONSE_TIMEOUT)
end

def sc_cmd_radio(*command)
    count = tlm("CFS_RADIO SC_HKTLM CMDCTR") + 1

    if (count == 256)
        count = 0
    end

    cmd *command
    sleep(CFS_RADIO_CMD_SLEEP)
    get_sc_hk_radio()
    current = tlm("CFS_RADIO SC_HKTLM CMDCTR")
    if (current != count)
        # Try again
        cmd *command
        sleep(CFS_RADIO_CMD_SLEEP)
        get_sc_hk_radio()
        current = tlm("CFS_RADIO SC_HKTLM CMDCTR")
        if (current != count)
            # Third times the charm
            cmd *command
            sleep(CFS_RADIO_CMD_SLEEP)
            get_sc_hk_radio()
            current = tlm("CFS_RADIO SC_HKTLM CMDCTR")
        end
    end
    check("CFS_RADIO SC_HKTLM CMDCTR >= #{count}")
end

#
# Misc. Functions
#
def set_met_radio()
    # Constant number of seconds from Jan 1, 1958 to Jan 1, 1970 (4383 days)
    seconds_from_tai_to_unix_epoch = 378691200
    set_met_timeout = 5
    set_met_success = false

    # Request current spacecraft time
    cmd("CFS_RADIO CFE_TIME_SEND_HK")

    # Obtain current unix timestamp from ruby
    current_time = Time.now.to_i

    # Convert current unix time to TAI time
    cfs_seconds = current_time + seconds_from_tai_to_unix_epoch
    # Subseconds must be 0 or cFS will reject the new time
    cfs_subseconds = 0

    # Send the command to cFS
    cmd("CFS_RADIO CFE_TIME_SET_MET with SECONDS #{cfs_seconds}, MICROSECONDS #{cfs_subseconds}")
end

# Jam spacecraft mission elapsed time with the current time on the ground
# Note that this call requires the "leo_bus" target to be in use
def set_met_from_ground()
    # Constant number of seconds from Jan 1, 1958 to Jan 1, 1970 (4383 days)
    seconds_from_tai_to_unix_epoch = 378691200
    set_met_timeout = 30
    attempts = 0
    max_attempts = 5
    set_met_success = false

    # Obtain starting command counters
    wait_check_packet("CFS_RADIO", "CFE_TIME_HKPACKET", 1, set_met_timeout)
    time_cmd_counter = tlm("CFS_RADIO CFE_TIME_HKPACKET CMDCOUNTER")
    wait_check_packet("LEO_BUS_RADIO", "LEO_BUS_HK_TLM_T", 1, set_met_timeout)
    leo_bus_cmd_counter = tlm("LEO_BUS_RADIO LEO_BUS_HK_TLM_T COMMANDCOUNT")

    while attempts < max_attempts and set_met_success == false
        # Obtain current unix timestamp in UTC from ruby
        current_time = Time.now.getutc.to_i

        # Convert current unix time to TAI time
        cfs_seconds = current_time + seconds_from_tai_to_unix_epoch
        # Subseconds must be 0 or cFS will reject the new time
        cfs_subseconds = 0

        # Send the command to cFS
        cmd("CFS_RADIO CFE_TIME_SET_MET with SECONDS #{cfs_seconds}, MICROSECONDS #{cfs_subseconds}")
        wait_check_packet("CFS_RADIO", "CFE_TIME_HKPACKET", 1, set_met_timeout)
        new_time_cmd_counter = tlm("CFS_RADIO CFE_TIME_HKPACKET CMDCOUNTER")
        if new_time_cmd_counter > time_cmd_counter
            set_met_success = true
        end
        attempts = attempts + 1
    end
    raise 'Failed to set cFS MET!' if attempts >= max_attempts

    # Reset previous number of attempts
    attempts = 0
    set_met_success = false

    while attempts < max_attempts and set_met_success == false
        # Tell LEO_BUS to save the new time to disk
        cmd("LEO_BUS_RADIO LEO_BUS_SAVE_MET_TO_FILE_CC")
        wait_check_packet("LEO_BUS_RADIO", "LEO_BUS_HK_TLM_T", 1, set_met_timeout)
        new_leo_bus_cmd_counter = tlm("LEO_BUS_RADIO LEO_BUS_HK_TLM_T COMMANDCOUNT")
        if new_leo_bus_cmd_counter > leo_bus_cmd_counter
            set_met_success = true
        end
        attempts = attempts + 1
    end
    raise 'Failed to send LEO_BUS SAVE_MET_TO_FILE command!' if attempts >= max_attempts
end
