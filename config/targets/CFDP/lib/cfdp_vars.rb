# CFDP TASK VARS
PDU_TARGET_NAME_TX = "PDU_TX"
PDU_TARGET_NAME_RX = "PDU_RX"
PDU_SEND_TARGET_PACKET = "CF_GND_TO_SPACE_PDU"
PDU_RECV_TARGET_PACKET = "CF_SPACE_TO_GND_PDU"

# CFDP ENGINE VARS
# How many seconds before receiving a response
EOF_TIMEOUT = 5
INACTIVITY_TIMEOUT = 5
FINISHED_TIMEOUT = 30
NAK_TIMEOUT = 5
FINISH_LOG_TIMEOUT = 5 # seconds before closing the logFile

# How many times before performing an error
EOF_LIMIT = 25
INACTIVITY_LIMIT = 25
FINISHED_LIMIT = 25
NAK_LIMIT = 100
FINISH_LOG_LIMIT = 25

# CONSTRAINTS
MYID = 21
DESTINATIONID = 24
USE_CRC = 0						# (0 - false, 1 - true). CRC is not supported @ CFS CF
MAX_PDU_SIZE = 256				# Bytes
MAX_STRING_SIZE = 64			# Used for destination and source file names
SAVE_FILE_UPON_ERROR = true 	# Choose whether to save file or not if error

# FILE VARS
LOG_DIRECTORY = "#{Cosmos::USERPATH}/outputs/logs/"
PDULOG = "CFDP_PDU_Received"
ERRORLOG = "CFDP_Error_Log"

# ENGINE TASK VARS
SLEEP_TIME_BTW_PDUS = 0.05	    # time sleeping between sending pdus

# OTHERS
DEBUG = 0