require 'mission_lib'

# First, make sure we can contact the SC and we can receive data from it
enable_TO_and_verify()
sleep(20)

# Second, check out battery health
prompt("Proceed with battery voltage check, Press OK to continue.")
wait_check_packet("GENERIC_EPS_RADIO", "GENERIC_EPS_HK_TLM", 1, 10) 
battery_bus_voltage = tlm("GENERIC_EPS_RADIO GENERIC_EPS_HK_TLM BATT_VOLTAGE")
message_box("Battery bus voltage reported to be #{battery_bus_voltage} volts.", "OK", false)

# Third, verify SC State
prompt("Proceed with Manager SC Mode check, Press OK to continue.")
wait_check_packet("MGR_RADIO", "MGR_HK_TLM", 1, 10) 
sc_mode = tlm("MGR_RADIO MGR_HK_TLM SPACECRAFT_MODE")
message_box("Spacecraft Mode reported to be #{sc_mode}.", "OK", false)

# Fourth, check for any anomalous reboots since launch
prompt("Proceed with Anomalous Reboot check, Press OK to continue.")
wait_check_packet("MGR_RADIO", "MGR_HK_TLM", 1, 10) 
ar_cnt = tlm("MGR_RADIO MGR_HK_TLM ANOM_REBOOT_COUNTER")
message_box("Anomalous reboot counter reported to be #{ar_cnt}.", "OK", false)

# Fifth, Instrument first light?
prompt("Proceed with Instrument First Light!, Press OK to continue.")
cmd("SAMPLE_RADIO SAMPLE_ENABLE_CC")
prompt("Check Sample Data for streaming telemetry, dismiss this prompt when done.")
message_box("Press OK to disable sample device.", "OK", false)
cmd("SAMPLE_RADIO SAMPLE_DISABLE_CC")

# Sixth, configure Science Regions to later be used
prompt("About to configure science regions, Press OK to continue.")
cmd("MGR_RADIO MGR_SET_AK_CC with AK_STATUS ENABLE")
cmd("MGR_RADIO MGR_SET_CONUS_CC with CONUS_STATUS ENABLE")
cmd("MGR_RADIO MGR_SET_HI_CC with HI_STATUS ENABLE")

# Seventh, complete pass and turn off radio
prompt("STF commissioning complete!  Press OK to turn off SC Radio.")
cmd("CFS_RADIO TO_DISABLE_OUTPUT")
