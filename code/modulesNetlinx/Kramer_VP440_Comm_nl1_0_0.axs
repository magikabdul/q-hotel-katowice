MODULE_NAME='Kramer_VP440_Comm_nl1_0_0' (DEV VIRTUAL, DEV REAL)
(***********************************************************)
(*  FILE CREATED ON: 04/14/2017  AT: 10:16:00              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 06/01/2017  AT: 19:39:14        *)
(***********************************************************)
#INCLUDE 'SNAPI';
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

VOLATILE INTEGER tlMaintainConnection = 1;
VOLATILE INTEGER tlBufferRx = 2;
VOLATILE INTEGER tlBufferTx = 3;
VOLATILE INTEGER tlSetOffline = 4;
(***********************************************************)
(*              STRUCTURE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

STRUCT __KRAMER_BUFFER {
	CHAR rx[1000]
	CHAR tx[100]
}

STRUCT __KRAMER_STATUS {
	CHAR isOnline[5]
}

STRUCT __SETTINGS_RS {
	CHAR baud[10]
}

STRUCT __KRAMER_SETTINGS {
	__SETTINGS_RS rs
}

STRUCTURE __KRAMER
{
	__KRAMER_SETTINGS settings
	__KRAMER_STATUS status
	__KRAMER_BUFFER buffer
}
(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

VOLATILE __KRAMER kramer

VOLATILE LONG ltimesMaintainConnection[] = {10000};
VOLATILE LONG ltimesBufferRx[] = {100};
VOLATILE LONG ltimesBufferTx[] = {500};
VOLATILE LONG ltimesSetOffline[] = {15000};
(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)
DEFINE_FUNCTION kramerDebug(CHAR message[])
{
	SEND_STRING 0,"'############### KRAMER ##############'";
	SEND_STRING 0,"'TRACE: ',message";
	SEND_STRING 0,"'############### KRAMER ##############'";
}

DEFINE_FUNCTION kramerBufferTxAdd(CHAR message[])
{
	kramer.buffer.tx = "kramer.buffer.tx, message, $0D"
}

DEFINE_FUNCTION setControlMethod()
{
	IF(REAL.NUMBER <> 0)
		kramer.settings.rs.baud = '9600';

	kramer.status.isOnline = 'false';

	TIMELINE_CREATE(tlMaintainConnection, ltimesMaintainConnection, LENGTH_ARRAY(ltimesMaintainConnection), TIMELINE_ABSOLUTE, TIMELINE_REPEAT)
	TIMELINE_CREATE(tlBufferRx, ltimesBufferRx, LENGTH_ARRAY(ltimesBufferRx), TIMELINE_ABSOLUTE, TIMELINE_REPEAT)
	TIMELINE_CREATE(tlBufferTx, ltimesBufferTx, LENGTH_ARRAY(ltimesBufferTx), TIMELINE_ABSOLUTE, TIMELINE_REPEAT)

	kramerDebug("'setControlMethod --- control method is being set to [rs232]'")
}
(***********************************************************)
(*                 STARTUP CODE GOES BELOW                 *)
(***********************************************************)
DEFINE_START

setControlMethod();
(***********************************************************)
(*                  THE EVENTS GO BELOW                    *)
(***********************************************************)
DEFINE_EVENT

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														    						 maintainConnection
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
TIMELINE_EVENT[tlMaintainConnection]
{
	IF(kramer.status.isOnline == 'false')
	{
		SEND_COMMAND REAL,"'SET BAUD ', kramer.settings.rs.baud, ',8,N,1 485 DISABLE'"
		SEND_COMMAND REAL,"'HSOFF'"
		SEND_COMMAND REAL,"'RXON'"
	}
}

TIMELINE_EVENT[tlSetOffline]
{
	OFF[VIRTUAL, DEVICE_COMMUNICATING]
	OFF[VIRTUAL, DATA_INITIALIZED]
	OFF[VIRTUAL, POWER_FB]
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														    						   realDeviceStatus
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
DATA_EVENT[REAL]
{
	ONLINE:
	{
		kramer.status.isOnline = 'true'

		SEND_COMMAND REAL,"'SET BAUD ', kramer.settings.rs.baud, ',8,N,1 485 DISABLE'"
		SEND_COMMAND REAL,"'HSOFF'"
		SEND_COMMAND REAL,"'RXON'"
	}
	OFFLINE:
	{
		kramer.status.isOnline = 'false';
		OFF[VIRTUAL, DEVICE_COMMUNICATING]
		OFF[VIRTUAL, DATA_INITIALIZED]
		OFF[VIRTUAL, POWER_FB]
	}
	STRING:
	{
		kramer.buffer.rx = "kramer.buffer.rx, DATA.TEXT"
		kramerDebug("'RX STRING: [', DATA.TEXT, ']' ")
	}
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														    						     moduleSettings
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
DATA_EVENT[VIRTUAL]
{
	COMMAND:
	{
		IF(FIND_STRING(DATA.TEXT, 'PROPERTY-', 1))
		{
			REMOVE_STRING(DATA.TEXT, 'PROPERTY-', 1)

			IF(FIND_STRING(DATA.TEXT, 'IP_Address,', 1))
			{
				REMOVE_STRING(DATA.TEXT, 'IP_Address,', 1)
				//kramer.settings.ip.address = DATA.TEXT
			}
			ELSE IF(FIND_STRING(DATA.TEXT, 'IP_Port,', 1))
			{
				REMOVE_STRING(DATA.TEXT, 'IP_Port,', 1)
				//kramer.settings.ip.port = ATOI(DATA.TEXT)
			}
		}
	}
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														    						     			 bufferTx
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
TIMELINE_EVENT[tlBufferTx]
{
	STACK_VAR CHAR tempBufferTx[100]

	IF(kramer.status.isOnline == 'true')
	{
		IF(FIND_STRING(kramer.buffer.tx, "$0D", 1))
		{
			tempBufferTx = REMOVE_STRING(kramer.buffer.tx, "$0D", 1)
			SEND_STRING REAL, tempBufferTx
			kramerDebug("'SEND MESSAGE --- [', tempBufferTx, ']'")
		}
	}
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														    						     			 bufferRx
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
TIMELINE_EVENT[tlBufferRx]
{
	STACK_VAR CHAR temporaryBufferRx[100]

	IF(FIND_STRING(kramer.buffer.rx, "$0D,$0A", 1))
	{
		ON[VIRTUAL, DATA_INITIALIZED]
		ON[VIRTUAL, POWER_FB]

		temporaryBufferRx = REMOVE_STRING(kramer.buffer.rx, "$0D,$0A", 1)

		//maintain communication between amx and ecler
		IF(FIND_STRING(temporaryBufferRx, "'~01@ OK'", 1))
		{
			//kramerBufferTxAdd('#');
			ON[VIRTUAL, DEVICE_COMMUNICATING]

			IF(TIMELINE_ACTIVE(tlSetOffline))
				TIMELINE_SET(tlSetOffline,0)
			ELSE
				TIMELINE_CREATE(tlSetOffline,ltimesSetOffline,LENGTH_ARRAY(ltimesSetOffline),TIMELINE_ABSOLUTE,TIMELINE_ONCE)
		}
	}
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														    					 moduleBasicFunctions
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
DATA_EVENT[VIRTUAL]
{
	COMMAND:
	{
		IF(FIND_STRING(DATA.TEXT, 'REINIT', 1))
		{
			TIMELINE_PAUSE(tlMaintainConnection)
			WAIT 30
				TIMELINE_RESTART(tlMaintainConnection)

			OFF[VIRTUAL, DATA_INITIALIZED]
			OFF[VIRTUAL, DEVICE_COMMUNICATING]

			kramer.buffer.tx = '';
			IF(TIMELINE_ACTIVE(tlBufferTx))
			{
				TIMELINE_SET(tlBufferTx,0)
				TIMELINE_PAUSE(tlBufferTx)
				WAIT 20
					TIMELINE_RESTART(tlBufferTx)
			}

			kramer.buffer.rx = '';
			IF(TIMELINE_ACTIVE(tlBufferRx))
			{
				TIMELINE_SET(tlBufferRx,0)
				TIMELINE_PAUSE(tlBufferRx)
				WAIT 20
					TIMELINE_RESTART(tlBufferRx)
			}
		}

		ELSE IF(FIND_STRING(DATA.TEXT, 'PASSTHRU-', 1))
		{
			REMOVE_STRING(DATA.TEXT, 'PASSTHRU-', 1)
			kramerBufferTxAdd(DATA.TEXT)
		}
	}
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														    					 moduleBasicFunctions
// INPUT-HDBT_1,1
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
DATA_EVENT[VIRTUAL]
{
	COMMAND:
	{
		STACK_VAR INTEGER nInput
		STACK_VAR INTEGER nOutput

		IF(FIND_STRING(DATA.TEXT, 'INPUT-', 1))
		{
			REMOVE_STRING(DATA.TEXT, 'INPUT-', 1)

			IF(FIND_STRING(DATA.TEXT, 'OFF,', 1))
			{
				REMOVE_STRING(DATA.TEXT, 'OFF,', 1)
				kramerBufferTxAdd("'#ROUTE 12,', DATA.TEXT, ',x'")
			}
			ELSE IF(FIND_STRING(DATA.TEXT, 'HDMI_', 1))
			{
				REMOVE_STRING(DATA.TEXT, 'HDMI_', 1)
				nInput = ATOI(REMOVE_STRING(DATA.TEXT, ',', 1)) - 1

				SELECT
				{
					ACTIVE(DATA.TEXT == 'ROOM'):		nOutput = 1
					ACTIVE(DATA.TEXT == 'REMOTE'):	nOutput = 1
				}
				kramerBufferTxAdd("'#ROUTE 12,', ITOA(nOutput), ',', ITOA(nInput)")
			}
		}
	}
}