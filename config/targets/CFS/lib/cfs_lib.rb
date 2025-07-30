require 'cosmos'
require 'cosmos/script'

#
# Definitions
#
CFS_CMD_SLEEP = 0.25
CFS_RESPONSE_TIMEOUT = 5
CFS_TEST_LOOP_COUNT = 1

#
# CCSDS File Delivery Protocol (CF)
#
def get_cf_hk()
    cmd("CFS CF_SEND_HK")
    wait_check_packet("CFS", "CF_HKPACKET", 1, CFS_RESPONSE_TIMEOUT)
end

def cf_cmd(*command)
    count = tlm("CFS CF_HKPACKET CMDCOUNTER") + 1

    if (count == 256)
        count = 0
    end

    cmd *command
    sleep(CFS_CMD_SLEEP)
    get_cf_hk()
    current = tlm("CFS CF_HKPACKET CMDCOUNTER")
    if (current != count)
        # Try again
        cmd *command
        sleep(CFS_CMD_SLEEP)
        get_cf_hk()
        current = tlm("CFS CF_HKPACKET CMDCOUNTER")
        if (current != count)
            # Third times the charm
            cmd *command
            sleep(CFS_CMD_SLEEP)
            get_cf_hk()
            current = tlm("CFS CF_HKPACKET CMDCOUNTER")
        end
    end
    check("CFS CF_HKPACKET CMDCOUNTER >= #{count}")
end

#
# Data Storage (DS)
#
def get_ds_hk()
    cmd("CFS DS_SEND_HK")
    wait_check_packet("CFS", "DS_HKPACKET", 1, CFS_RESPONSE_TIMEOUT)
end

def ds_cmd(*command)
    count = tlm("CFS DS_HKPACKET CMDACCEPTEDCOUNTER") + 1

    if (count == 256)
        count = 0
    end

    cmd *command
    sleep(CFS_CMD_SLEEP)
    get_ds_hk()
    current = tlm("CFS DS_HKPACKET CMDACCEPTEDCOUNTER")
    if (current != count)
        # Try again
        cmd *command
        sleep(CFS_CMD_SLEEP)
        get_ds_hk()
        current = tlm("CFS DS_HKPACKET CMDACCEPTEDCOUNTER")
        if (current != count)
            # Third times the charm
            cmd *command
            sleep(CFS_CMD_SLEEP)
            get_ds_hk()
            current = tlm("CFS DS_HKPACKET CMDACCEPTEDCOUNTER")
        end
    end
    check("CFS DS_HKPACKET CMDACCEPTEDCOUNTER >= #{count}")
end

#
# File Manager (FM)
#
def get_fm_hk()
    cmd("CFS FM_SEND_HK")
    wait_check_packet("CFS", "FM_HOUSEKEEPINGPKT", 1, CFS_RESPONSE_TIMEOUT)
end

def fm_cmd(*command)
    count = tlm("CFS FM_HOUSEKEEPINGPKT COMMANDCOUNTER") + 1

    if (count == 256)
        count = 0
    end

    cmd *command
    sleep(CFS_CMD_SLEEP)
    get_fm_hk()
    current = tlm("CFS FM_HOUSEKEEPINGPKT COMMANDCOUNTER")
    if (current != count)
        # Try again
        cmd *command
        sleep(CFS_CMD_SLEEP)
        get_fm_hk()
        current = tlm("CFS FM_HOUSEKEEPINGPKT COMMANDCOUNTER")
        if (current != count)
            # Third times the charm
            cmd *command
            sleep(CFS_CMD_SLEEP)
            get_fm_hk()
            current = tlm("CFS FM_HOUSEKEEPINGPKT COMMANDCOUNTER")
        end
    end
    check("CFS FM_HOUSEKEEPINGPKT COMMANDCOUNTER >= #{count}")
end

def get_fm_files(directory, offset)
    cmd("CFS FM_GET_DIR_PKT with DIRECTORY '#{directory}', DIRLISTOFFSET #{offset}, GETSIZETIMEMODE 0xFFFFFFFF")
    wait_check_packet("CFS", "FM_DIRLISTPKT", 1, CFS_RESPONSE_TIMEOUT)
end

#
# Limit Checker (LC)
#
def get_lc_hk()
    cmd("CFS LC_SEND_HK")
    wait_check_packet("CFS", "LC_HKPACKET", 1, CFS_RESPONSE_TIMEOUT)
end

def lc_cmd(*command)
    count = tlm("CFS LC_HKPACKET CMDCOUNT") + 1

    if (count == 256)
        count = 0
    end

    cmd *command
    sleep(CFS_CMD_SLEEP)
    get_lc_hk()
    current = tlm("CFS LC_HKPACKET CMDCOUNT")
    if (current != count)
        # Try again
        cmd *command
        sleep(CFS_CMD_SLEEP)
        get_lc_hk()
        current = tlm("CFS LC_HKPACKET CMDCOUNT")
        if (current != count)
            # Third times the charm
            cmd *command
            sleep(CFS_CMD_SLEEP)
            get_lc_hk()
            current = tlm("CFS LC_HKPACKET CMDCOUNT")
        end
    end
    check("CFS LC_HKPACKET CMDCOUNT >= #{count}")
end

#
# Stored Commands (SC)
#
def get_sc_hk()
    cmd("CFS SC_SEND_HK")
    wait_check_packet("CFS", "SC_HKTLM", 1, CFS_RESPONSE_TIMEOUT)
end

def sc_cmd(*command)
    count = tlm("CFS SC_HKTLM CMDCTR") + 1

    if (count == 256)
        count = 0
    end

    cmd *command
    sleep(CFS_CMD_SLEEP)
    get_sc_hk()
    current = tlm("CFS SC_HKTLM CMDCTR")
    if (current != count)
        # Try again
        cmd *command
        sleep(CFS_CMD_SLEEP)
        get_sc_hk()
        current = tlm("CFS SC_HKTLM CMDCTR")
        if (current != count)
            # Third times the charm
            cmd *command
            sleep(CFS_CMD_SLEEP)
            get_sc_hk()
            current = tlm("CFS SC_HKTLM CMDCTR")
        end
    end
    check("CFS SC_HKTLM CMDCTR >= #{count}")
end

#
# Misc. Functions
#
def set_met()
    # Constant number of seconds from Jan 1, 1958 to Jan 1, 1970 (4383 days)
    seconds_from_tai_to_unix_epoch = 378691200
    set_met_timeout = 5
    set_met_success = false

    # Request current spacecraft time
    cmd("CFS CFE_TIME_SEND_HK")

    # Obtain current unix timestamp from ruby
    current_time = Time.now.to_i

    # Convert current unix time to TAI time
    cfs_seconds = current_time + seconds_from_tai_to_unix_epoch
    # Subseconds must be 0 or cFS will reject the new time
    cfs_subseconds = 0

    # Send the command to cFS
    cmd("CFS CFE_TIME_SET_MET with SECONDS #{cfs_seconds}, MICROSECONDS #{cfs_subseconds}")
end
