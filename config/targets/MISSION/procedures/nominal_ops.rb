require 'mission_lib'

enable_TO_and_verify()
sleep(1)

battery_threshold = 15.00 # volts
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

obtain_file_list_cam()

puts "STF nominal pass script complete!  Perform any necessary commanding now."
raise "Pausing script - press go to resume and conclude the pass."

cmd("CFS_RADIO TO_DISABLE_OUTPUT")
