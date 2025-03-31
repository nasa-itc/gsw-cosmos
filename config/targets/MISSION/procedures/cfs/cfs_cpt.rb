# Setup radio and enable instruments
cmd("CFS_RADIO TO_ENABLE_OUTPUT with DEST_IP 'radio_sim', DEST_PORT 5011")

# check all systems housekeeping and data packets each cycle
cmd("CFS_RADIO CFE_SB_SEND_SB_STATS")
sleep(CFS_CMD_SLEEP)

cmd("CFS_RADIO CFE_TIME_DIAG_TLM")
cmd("CFS_RADIO CFE_TIME_SEND_HK")
sleep(CFS_CMD_SLEEP)

cmd("CFS_RADIO CF_SEND_CFG_PARAMS")
cmd("CFS_RADIO CF_SEND_HK")
sleep(CFS_CMD_SLEEP)

cmd("CFS_RADIO CI_GET_HK")
sleep(CFS_CMD_SLEEP)

cmd("CFS_RADIO SCH_SEND_DIAG_TLM")
sleep(CFS_CMD_SLEEP)

cmd("CFS_RADIO SC_SEND_HK")
sleep(CFS_CMD_SLEEP)

cmd("CFS_RADIO CFE_ES_NOOP")
cmd("CFS_RADIO CFE_EVS_NO_OPERATION")
cmd("CFS_RADIO CFE_SB_NOOP")
sleep(CFS_CMD_SLEEP)
cmd("CFS_RADIO CFE_TBL_NOOP")
cmd("CFS_RADIO CFE_TIME_NOOP")
cmd("CFS_RADIO CF_NOOP")
sleep(CFS_CMD_SLEEP)
cmd("CFS_RADIO CI_NOOP_CC")
cmd("CFS_RADIO CS_NOOP")
cmd("CFS_RADIO DS_NOOP")
sleep(CFS_CMD_SLEEP)
cmd("CFS_RADIO FM_NOOP")
cmd("CFS_RADIO HS_NOOP")
cmd("CFS_RADIO LC_NOOP")
sleep(CFS_CMD_SLEEP)
cmd("CFS_RADIO MD_NOOP")
cmd("CFS_RADIO MM_NOOP")
cmd("CFS_RADIO SCH_NOOP")
sleep(CFS_CMD_SLEEP)

#CFDP Large C1
# Confirm radio operational
enable_TO_and_verify()
# Uplink
cmd("CFS_RADIO FM_DELETE with FILENAME '/data/tmp1_c1.so'")
initial_success_count = tlm("CFDP CFDP_ENGINE_HK ENG_TOTALSUCCESSTRANS")
wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 0", 10)
cmd("CFDP SEND_FILE with CLASS 1, DEST_ID '24', SRCFILENAME '/tmp/nos3/uplink/tmp1.so', DSTFILENAME '/data/tmp1_c1.so'")
wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 1", 10)
wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 0", 180)
check("CFDP CFDP_ENGINE_HK ENG_TOTALSUCCESSTRANS > #{initial_success_count}")
sleep 5
# Downlink
wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 0", 10)
initial_success_count = tlm("CFDP CFDP_ENGINE_HK ENG_TOTALSUCCESSTRANS")
cmd("CFS_RADIO CF_TX_FILE with CLASS 'CLASS 1 - NO FEEDBACK', KEEP 'KEEP', CHAN_NUM 'CHAN 0', PRIORITY 1, DEST_ID 0x18, SRCFILENAME '/data/tmp1_c1.so', DSTFILENAME '/tmp/nos3/data/tmp1_c1.so'")
wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 1", 10)
wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 0", 180)
wait_check("CFDP CFDP_ENGINE_HK ENG_TOTALSUCCESSTRANS > #{initial_success_count}", 20)

#CFDP Small C2
# Confirm radio operational
enable_TO_and_verify()
# Uplink
cmd("CFS_RADIO FM_DELETE with FILENAME '/data/tmp0_c2.so'")
initial_success_count = tlm("CFDP CFDP_ENGINE_HK ENG_TOTALSUCCESSTRANS")
wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 0", 10)
cmd("CFDP SEND_FILE with CLASS 2, DEST_ID '24', SRCFILENAME '/tmp/nos3/uplink/tmp0.so', DSTFILENAME '/data/tmp0_c2.so'")
wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 1", 10)
wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 0", 20)
check("CFDP CFDP_ENGINE_HK ENG_TOTALSUCCESSTRANS > #{initial_success_count}")
sleep 5
# Downlink
wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 0", 10)
initial_success_count = tlm("CFDP CFDP_ENGINE_HK ENG_TOTALSUCCESSTRANS")
cmd("CFS_RADIO CF_TX_FILE with CLASS 'CLASS 2 - WITH FEEDBACK', KEEP 'KEEP', CHAN_NUM 'CHAN 0', PRIORITY 1, DEST_ID 0x18, SRCFILENAME '/data/tmp0_c2.so', DSTFILENAME '/tmp/nos3/data/tmp0_c2.so'")
wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 1", 10)
wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 0", 20)
wait_check("CFDP CFDP_ENGINE_HK ENG_TOTALSUCCESSTRANS > #{initial_success_count}", 20)