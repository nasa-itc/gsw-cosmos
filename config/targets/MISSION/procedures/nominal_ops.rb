require 'mission_lib'

enable_TO_and_verify()
sleep(20)

battery_threshold = 23.00 # volts
battery_bus_voltage = tlm("GENERIC_EPS_RADIO GENERIC_EPS_HK_TLM BATT_VOLTAGE")

if battery_bus_voltage < battery_threshold
    should_cancel = message_box("Battery bus voltage below #{battery_threshold}V threshold! Abort pass?", 'Yes', 'No', false)
    case should_cancel
    when 'Yes'
        cmd("CFS_RADIO TO_PAUSE_OUTPUT")
    when 'No'
        wait(3) # Prompt twice to make sure user is REALLY sure
        really_should_cancel = message_box("Battery bus voltage below #{battery_threshold}V threshold! Abort pass?", 'Yes', 'No', false)
        case really_should_cancel
        when 'Yes'
            cmd("CFS_RADIO TO_PAUSE_OUTPUT")
        end 
    end
end

wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 0", 10)
initial_success_count = tlm("CFDP CFDP_ENGINE_HK ENG_TOTALSUCCESSTRANS")
cmd("CFS_RADIO CF_TX_FILE with CLASS 'CLASS 2 - WITH FEEDBACK', KEEP 'KEEP', CHAN_NUM 'CHAN 0', PRIORITY 1, DEST_ID 0x18, SRCFILENAME '/data/dummy.txt', DSTFILENAME '/tmp/nos3/data/dummy.txt'")
wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 1", 10)
wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 0", 400)
wait_check("CFDP CFDP_ENGINE_HK ENG_TOTALSUCCESSTRANS > #{initial_success_count}", 20)

puts "STF nominal pass script complete!  Perform any necessary commanding now."
raise "Pausing script - press go to resume and conclude the pass."

cmd("CFS_RADIO TO_DISABLE_OUTPUT")
