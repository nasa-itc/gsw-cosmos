require 'cosmos'
require 'cosmos/script'
require 'mission_lib.rb'

class COM < Cosmos::Test
    def setup
        cmd("CFS_RADIO TO_ENABLE_OUTPUT with DEST_IP 'radio_sim', DEST_PORT 5011")
    end

    def test_debug
        start("com/debug.rb")
    end

    def test_radio
        start("com/radio.rb")
    end

    def teardown
        cmd("CFS_RADIO TO_PAUSE_OUTPUT")
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
        wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 0", 90)
        check("CFDP CFDP_ENGINE_HK ENG_TOTALSUCCESSTRANS > #{initial_success_count}")
        sleep 5
        # Downlink
        wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 0", 10)
        initial_success_count = tlm("CFDP CFDP_ENGINE_HK ENG_TOTALSUCCESSTRANS")
        cmd("CFS_RADIO CF_TX_FILE with CLASS 'CLASS 1 - NO FEEDBACK', KEEP 'KEEP', CHAN_NUM 'CHAN 0', PRIORITY 1, DEST_ID 0x18, SRCFILENAME '/data/tmp1_c1.so', DSTFILENAME '/tmp/nos3/data/tmp1_c1.so'")
        wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 1", 10)
        wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 0", 90)
        wait_check("CFDP CFDP_ENGINE_HK ENG_TOTALSUCCESSTRANS > #{initial_success_count}", 20)
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
        wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 0", 90)
        check("CFDP CFDP_ENGINE_HK ENG_TOTALSUCCESSTRANS > #{initial_success_count}")
        sleep 5
        # Downlink
        wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 0", 10)
        initial_success_count = tlm("CFDP CFDP_ENGINE_HK ENG_TOTALSUCCESSTRANS")
        cmd("CFS_RADIO CF_TX_FILE with CLASS 'CLASS 2 - WITH FEEDBACK', KEEP 'KEEP', CHAN_NUM 'CHAN 0', PRIORITY 1, DEST_ID 0x18, SRCFILENAME '/data/tmp1_c2.so', DSTFILENAME '/tmp/nos3/data/tmp1_c2.so'")
        wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 1", 10)
        wait_check("CFDP CFDP_ENGINE_HK ENG_INPROGRESSTRANS == 0", 90)
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

class Mission_Test < Cosmos::TestSuite
    def initialize
        super()
        add_test('COM')
        add_test('LPT')
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
