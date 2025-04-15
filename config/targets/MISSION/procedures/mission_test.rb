require 'cosmos'
require 'cosmos/script'
require 'mission_lib.rb'

class COM < Cosmos::Test
    def setup
        enable_TO_and_verify()
    end

    def test_debug
        start("com/debug.rb")
    end

    def test_radio
        # Confirm radio operational
        enable_TO_and_verify()
    end

    def teardown
        cmd("CFS_RADIO TO_PAUSE_OUTPUT")
    end
end

class CFS < Cosmos::Test
    def setup
        
    end

    def test_cfs_lpt
        
    end

    def test_cfs_cpt

    end

    def teardown
        
    end
end

class LPT < Cosmos::Test
    # Limited Performance Test

    def setup
        # Confirm radio operational
        enable_TO_and_verify()
    end

    def test_cfdp_large_c1
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

        #Sample
        cmd("SAMPLE SAMPLE_ENABLE_CC")
        cmd("SAMPLE SAMPLE_RST_COUNTERS_CC")
        sleep 10
        current = tlm("SAMPLE SAMPLE_HK_TLM CMD_COUNT")
        cmd("SAMPLE SAMPLE_NOOP_CC")
        sleep 10
        check("SAMPLE SAMPLE_HK_TLM CMD_COUNT > #{current}")
        cmd("SAMPLE SAMPLE_DISABLE_CC")

        #Arducam
        cmd("ARDUCAM CAM_RESET_COUNTERS_CC")
        sleep 10
        current = tlm("ARDUCAM ARDUCAM_HK_TLM_T COMMANDCOUNT")
        cmd("ARDUCAM CAM_NOOP_CC")
        sleep 10
        check("ARDUCAM ARDUCAM_HK_TLM_T COMMANDCOUNT > #{current}")

        #adcs
        cmd("GENERIC_ADCS GENERIC_ADCS_RST_COUNTERS_CC")
        sleep 10
        current = tlm("GENERIC_ADCS GENERIC_ADCS_HK_TLM CMD_COUNT")
        cmd("GENERIC_ADCS GENERIC_ADCS_NOOP_CC")
        sleep 10
        check("GENERIC_ADCS GENERIC_ADCS_HK_TLM CMD_COUNT > #{current}")

        #css
        cmd("GENERIC_CSS GENERIC_CSS_ENABLE_CC")
        cmd("GENERIC_CSS GENERIC_CSS_RST_COUNTERS_CC")
        sleep 10
        current = tlm("GENERIC_CSS GENERIC_CSS_HK_TLM CMD_COUNT")
        cmd("GENERIC_CSS GENERIC_CSS_NOOP_CC")
        sleep 10
        check("GENERIC_CSS GENERIC_CSS_HK_TLM CMD_COUNT > #{current}")
        cmd("GENERIC_CSS GENERIC_CSS_DISABLE_CC")

        #eps
        cmd("GENERIC_EPS GENERIC_EPS_RST_COUNTERS_CC")
        sleep 10
        current = tlm("GENERIC_EPS GENERIC_EPS_HK_TLM CMD_COUNT")
        cmd("GENERIC_EPS GENERIC_EPS_NOOP_CC")
        sleep 10
        check("GENERIC_EPS GENERIC_EPS_HK_TLM CMD_COUNT > #{current}")

        #fss
        cmd("GENERIC_FSS GENERIC_FSS_ENABLE_CC")
        cmd("GENERIC_FSS GENERIC_FSS_RST_COUNTERS_CC")
        sleep 10
        current = tlm("GENERIC_FSS GENERIC_FSS_HK_TLM CMD_COUNT")
        cmd("GENERIC_FSS GENERIC_FSS_NOOP_CC")
        sleep 10
        check("GENERIC_FSS GENERIC_FSS_HK_TLM CMD_COUNT > #{current}")
        cmd("GENERIC_FSS GENERIC_FSS_DISABLE_CC")
        
        #imu
        cmd("GENERIC_IMU GENERIC_IMU_ENABLE_CC")
        cmd("GENERIC_IMU GENERIC_IMU_RST_COUNTERS_CC")
        sleep 10
        current = tlm("GENERIC_IMU GENERIC_IMU_HK_TLM CMD_COUNT")
        cmd("GENERIC_IMU GENERIC_IMU_NOOP_CC")
        sleep 10
        check("GENERIC_IMU GENERIC_IMU_HK_TLM CMD_COUNT > #{current}")
        cmd("GENERIC_IMU GENERIC_IMU_DISABLE_CC")

        #mag
        cmd("GENERIC_MAG GENERIC_MAG_ENABLE_CC")
        cmd("GENERIC_MAG GENERIC_MAG_RST_COUNTERS_CC")
        sleep 10
        current = tlm("GENERIC_MAG GENERIC_MAG_HK_TLM CMD_COUNT")
        cmd("GENERIC_MAG GENERIC_MAG_NOOP_CC")
        sleep 10
        check("GENERIC_MAG GENERIC_MAG_HK_TLM CMD_COUNT > #{current}")
        cmd("GENERIC_MAG GENERIC_MAG_DISABLE_CC")

        #rw
        cmd("GENERIC_REACTION_WHEEL GENERIC_RW_RST_COUNTERS_CC")
        cmd("GENERIC_REACTION_WHEEL GENERIC_RW_REQ_DATA_CC")
        sleep 10
        current = tlm("GENERIC_REACTION_WHEEL GENRW_HK_TLM_T COMMAND_COUNT")
        cmd("GENERIC_REACTION_WHEEL GENERIC_RW_NOOP_CC")
        cmd("GENERIC_REACTION_WHEEL GENERIC_RW_REQ_DATA_CC")
        sleep 10
        check("GENERIC_REACTION_WHEEL GENRW_HK_TLM_T COMMAND_COUNT > #{current}")
        
        #st
        cmd("GENERIC_STAR_TRACKER GENERIC_STAR_TRACKER_ENABLE_CC")
        cmd("GENERIC_STAR_TRACKER GENERIC_STAR_TRACKER_RST_COUNTERS_CC")
        cmd("GENERIC_STAR_TRACKER GENERIC_STAR_TRACKER_REQ_HK")
        sleep 10
        current = tlm("GENERIC_STAR_TRACKER GENERIC_STAR_TRACKER_HK_TLM CMD_COUNT")
        cmd("GENERIC_STAR_TRACKER GENERIC_STAR_TRACKER_NOOP_CC")
        cmd("GENERIC_STAR_TRACKER GENERIC_STAR_TRACKER_REQ_HK")
        sleep 10
        check("GENERIC_STAR_TRACKER GENERIC_STAR_TRACKER_HK_TLM CMD_COUNT > #{current}")
        cmd("GENERIC_STAR_TRACKER GENERIC_STAR_TRACKER_DISABLE_CC")

        #thruster
        cmd("GENERIC_THRUSTER GENERIC_THRUSTER_ENABLE_CC")
        cmd("GENERIC_THRUSTER GENERIC_THRUSTER_RST_COUNTERS_CC")
        cmd("GENERIC_THRUSTER GENERIC_THRUSTER_REQ_HK")
        sleep 10
        current = tlm("GENERIC_THRUSTER GENERIC_THRUSTER_HK_TLM CMD_COUNT")
        cmd("GENERIC_THRUSTER GENERIC_THRUSTER_NOOP_CC")
        cmd("GENERIC_THRUSTER GENERIC_THRUSTER_REQ_HK")
        sleep 10
        check("GENERIC_THRUSTER GENERIC_THRUSTER_HK_TLM CMD_COUNT > #{current}")
        cmd("GENERIC_THRUSTER GENERIC_THRUSTER_DISABLE_CC")

        # torquer
        cmd("GENERIC_TORQUER GENERIC_TORQUER_ENABLE_CC")
        cmd("GENERIC_TORQUER GENERIC_TORQUER_RST_COUNTERS_CC")
        sleep 10
        current = tlm("GENERIC_TORQUER GENERIC_TORQUER_HK_TLM_T CMD_COUNT")
        cmd("GENERIC_TORQUER GENERIC_TORQUER_NOOP_CC")
        sleep 10
        check("GENERIC_TORQUER GENERIC_TORQUER_HK_TLM_T CMD_COUNT > #{current}")
        cmd("GENERIC_TORQUER GENERIC_TORQUER_DISABLE_CC")

        # gps
        cmd("NOVATEL_OEM615 NOVATEL_OEM615_ENABLE_CC")
        cmd("NOVATEL_OEM615 NOVATEL_OEM615_RST_COUNTERS_CC")
        sleep 10
        current = tlm("NOVATEL_OEM615 NOVATEL_OEM615_HK_TLM CMD_COUNT")
        cmd("NOVATEL_OEM615 NOVATEL_OEM615_NOOP_CC")
        sleep 10
        check("NOVATEL_OEM615 NOVATEL_OEM615_HK_TLM CMD_COUNT > #{current}")
        cmd("NOVATEL_OEM615 NOVATEL_OEM615_DISABLE_CC")
    end

    def test_cfdp_large_c2
        # Confirm radio operational
        enable_TO_and_verify()
        # Uplink
        cmd("CFS_RADIO FM_DELETE with FILENAME '/data/tmp1_c2.so'")
        initial_success_count = tlm("CFDP CFDP_ENGINE_HK ENG_TOTALSUCCESSTRANS")
        wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 0", 10)
        cmd("CFDP SEND_FILE with CLASS 2, DEST_ID '24', SRCFILENAME '/tmp/nos3/uplink/tmp1.so', DSTFILENAME '/data/tmp1_c2.so'")
        wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 1", 10)
        wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 0", 180)
        check("CFDP CFDP_ENGINE_HK ENG_TOTALSUCCESSTRANS > #{initial_success_count}")
        sleep 5
        # Downlink
        wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 0", 10)
        initial_success_count = tlm("CFDP CFDP_ENGINE_HK ENG_TOTALSUCCESSTRANS")
        cmd("CFS_RADIO CF_TX_FILE with CLASS 'CLASS 2 - WITH FEEDBACK', KEEP 'KEEP', CHAN_NUM 'CHAN 0', PRIORITY 1, DEST_ID 0x18, SRCFILENAME '/data/tmp1_c2.so', DSTFILENAME '/tmp/nos3/data/tmp1_c2.so'")
        wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 1", 10)
        wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 0", 180)
        wait_check("CFDP CFDP_ENGINE_HK ENG_TOTALSUCCESSTRANS > #{initial_success_count}", 20)
    end
    
    def test_cfdp_small_c1
        # Confirm radio operational
        enable_TO_and_verify()
        # Uplink
        cmd("CFS_RADIO FM_DELETE with FILENAME '/data/tmp0_c1.so'")
        initial_success_count = tlm("CFDP CFDP_ENGINE_HK ENG_TOTALSUCCESSTRANS")
        wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 0", 10)
        cmd("CFDP SEND_FILE with CLASS 1, DEST_ID '24', SRCFILENAME '/tmp/nos3/uplink/tmp0.so', DSTFILENAME '/data/tmp0_c1.so'")
        wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 1", 10)
        wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 0", 20)
        check("CFDP CFDP_ENGINE_HK ENG_TOTALSUCCESSTRANS > #{initial_success_count}")
        sleep 5
        # Downlink
        wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 0", 10)
        initial_success_count = tlm("CFDP CFDP_ENGINE_HK ENG_TOTALSUCCESSTRANS")
        cmd("CFS_RADIO CF_TX_FILE with CLASS 'CLASS 1 - NO FEEDBACK', KEEP 'KEEP', CHAN_NUM 'CHAN 0', PRIORITY 1, DEST_ID 0x18, SRCFILENAME '/data/tmp0_c1.so', DSTFILENAME '/tmp/nos3/data/tmp0_c1.so'")
        wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 1", 10)
        wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 0", 20)
        wait_check("CFDP CFDP_ENGINE_HK ENG_TOTALSUCCESSTRANS > #{initial_success_count}", 20)
    end

    def test_cfdp_small_c2
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
    end

    def teardown
        cmd("CFS_RADIO TO_PAUSE_OUTPUT")
    end
end

class CFS < Cosmos::Test
    def setup
        
    end
  
    def test_cpt
        start("cfs/cfs_cpt.rb")
    end

    def test_lpt
        start("cfs/cfs_lpt.rb")
    end
  
    def teardown
    
    end
end

class Mission_Test < Cosmos::TestSuite
    def initialize
        super()
        add_test('COM')
        add_test('LPT')
        add_test('CFS')
    end

    def setup
        cmd("CFS LC_SET_LC_STATE with NEWLCSTATE LC_STATE_ACTIVE")
        enable_TO_and_verify()
    end
    
    def teardown
        cmd("CFS LC_SET_LC_STATE with NEWLCSTATE LC_STATE_DISABLED")
        cmd("CFS_RADIO TO_PAUSE_OUTPUT")
    end
end
