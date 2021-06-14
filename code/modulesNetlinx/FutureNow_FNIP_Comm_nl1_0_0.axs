MODULE_NAME='FutureNow_FNIP_Comm_nl1_0_0' (DEV VIRTUAL, DEV REAL)
(***********************************************************)
(*  FILE CREATED ON: 04/17/2017  AT: 14:19:22              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 07/25/2017  AT: 21:00:13        *)
(***********************************************************)

#INCLUDE 'SNAPI'

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

VOLATILE INTEGER tlMaintainConnection = 1;
VOLATILE INTEGER tlBufferRx = 2;
VOLATILE INTEGER tlBufferTx = 3;
VOLATILE INTEGER tlSetOffline = 4;

VOLATILE INTEGER tlScreenFrappeOpen = 11;
VOLATILE INTEGER tlScreenFrappeClose = 12;
VOLATILE INTEGER tlScreenMoccaOpen = 13;
VOLATILE INTEGER tlScreenMoccaClose = 14;
(***********************************************************)
(*              STRUCTURE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

STRUCT __FN_BUFFER {
	CHAR rx[1000]
	CHAR tx[100]
}

STRUCT __FN_STATUS {
	CHAR isOnline[5]
}

STRUCT __SETTINGS_IP {
	CHAR address[15]
	LONG port
}

STRUCT __FN_SETTINGS {
	CHAR contrlMethod[2]
	__SETTINGS_IP ip
}

STRUCTURE __FN
{
	__FN_SETTINGS settings
	__FN_STATUS status
	__FN_BUFFER buffer
}

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

VOLATILE __FN fn;

VOLATILE LONG ltimesMaintainConnection[] = {10000};
VOLATILE LONG ltimesBufferRx[] = {100};
VOLATILE LONG ltimesBufferTx[] = {200};
VOLATILE LONG ltimesSetOffline[] = {15000};
VOLATILE LONG ltimesScreen[] = {30000};
(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)
DEFINE_FUNCTION fnDebug(CHAR message[])
{
	SEND_STRING 0,"'############### FutureNow ##############'";
	SEND_STRING 0,"'TRACE: ',message";
	SEND_STRING 0,"'############### FutureNow ##############'";
}

DEFINE_FUNCTION fnBufferTxAdd(CHAR message[])
{
	fn.buffer.tx = "fn.buffer.tx, message, $0D"
}

DEFINE_FUNCTION setControlMethod()
{
	fn.settings.contrlMethod = 'ip';
	fn.settings.ip.port = 7078;

	fn.status.isOnline = 'false';

	TIMELINE_CREATE(tlMaintainConnection, ltimesMaintainConnection, LENGTH_ARRAY(ltimesMaintainConnection), TIMELINE_ABSOLUTE, TIMELINE_REPEAT)
	TIMELINE_CREATE(tlBufferRx, ltimesBufferRx, LENGTH_ARRAY(ltimesBufferRx), TIMELINE_ABSOLUTE, TIMELINE_REPEAT)
	TIMELINE_CREATE(tlBufferTx, ltimesBufferTx, LENGTH_ARRAY(ltimesBufferTx), TIMELINE_ABSOLUTE, TIMELINE_REPEAT)

	fnDebug("'setControlMethod --- control method is being set to [' , fn.settings.contrlMethod, ']'")
}

DEFINE_FUNCTION doClientConnect()
{
	STACK_VAR SLONG result

	IF(fn.status.isOnline <> 'true')
	{
		fn.buffer.tx = '';
		fn.buffer.rx = '';

		fnDebug("'doClientConnect --- attempting connection to ', fn.settings.ip.address, ':', ITOA(fn.settings.ip.port) , '...'")

		result = IP_CLIENT_OPEN(REAL.PORT ,fn.settings.ip.address, fn.settings.ip.port, IP_TCP)

		IF(result)
		{
			SELECT
			{
				ACTIVE(result == 1):	fnDebug("'doClientConnect --- invalid address [', fn.settings.ip.address, ']'")
				ACTIVE(result == 2):	fnDebug("'doClientConnect --- invalid port [', ITOA(fn.settings.ip.port), ']'")
				ACTIVE(result == 3):	fnDebug("'doClientConnect --- invalid protocol'")
				ACTIVE(result == 4):	fnDebug("'doClientConnect --- unable to connect'")
				ACTIVE(1):						fnDebug("'doClientConnect --- connection error'")
			}
		}
		ELSE
		{
			fnBufferTxAdd('#');
		}
	}
}
(***********************************************************)
(*                 STARTUP CODE GOES BELOW                 *)
(***********************************************************)
DEFINE_START

SET_VIRTUAL_PORT_COUNT(VIRTUAL, 2)

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
	IF(fn.status.isOnline == 'false')
	{
		IF(LENGTH_STRING(fn.settings.ip.address) > 0)
		{
			doClientConnect();
		}
	}
}

TIMELINE_EVENT[tlSetOffline]
{
	IF(fn.settings.contrlMethod == 'ip')
		IP_CLIENT_CLOSE(REAL.PORT)

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
		IF(fn.settings.contrlMethod == 'ip')
		{
			fn.status.isOnline = 'true';
			fnDebug("'ONLINE --- System connected to device IP: [', fn.settings.ip.address, ']'")
			ON[VIRTUAL, DATA_INITIALIZED]
		}
	}
	OFFLINE:
	{
		IF(fn.settings.contrlMethod == 'ip')
			IP_CLIENT_CLOSE(REAL.PORT);

		fn.status.isOnline = 'false';
		OFF[VIRTUAL, DEVICE_COMMUNICATING]
		OFF[VIRTUAL, DATA_INITIALIZED]
		OFF[VIRTUAL, POWER_FB]
	}
	STRING:
	{
		fn.buffer.rx = "fn.buffer.rx, DATA.TEXT"
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
				fn.settings.ip.address = DATA.TEXT
			}
			ELSE IF(FIND_STRING(DATA.TEXT, 'IP_Port,', 1))
			{
				REMOVE_STRING(DATA.TEXT, 'IP_Port,', 1)
				fn.settings.ip.port = ATOI(DATA.TEXT)
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

	IF(fn.status.isOnline == 'true')
	{
		IF(FIND_STRING(fn.buffer.tx, "$0D", 1))
		{
			tempBufferTx = REMOVE_STRING(fn.buffer.tx, "$0D", 1)
			SEND_STRING REAL, tempBufferTx
			fnDebug("'SEND MESSAGE --- [', tempBufferTx, ']'")
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

			fn.buffer.tx = '';
			IF(TIMELINE_ACTIVE(tlBufferTx))
			{
				TIMELINE_SET(tlBufferTx,0)
				TIMELINE_PAUSE(tlBufferTx)
				WAIT 20
					TIMELINE_RESTART(tlBufferTx)
			}

			fn.buffer.rx = '';
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
			fnBufferTxAdd(DATA.TEXT)
		}
	}
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														    					 				controlRelays
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
CHANNEL_EVENT[VIRTUAL.NUMBER:1:VIRTUAL.SYSTEM, 0]
{
	ON:
	{
		SELECT
		{			
			ACTIVE(CHANNEL.CHANNEL == MOTOR_CLOSE):
			{
				fnBufferTxAdd('FN,OFF,1')
				
				IF(!TIMELINE_ACTIVE(tlScreenFrappeClose))
				{
					TIMELINE_CREATE(tlScreenFrappeClose, ltimesScreen,  LENGTH_ARRAY(ltimesScreen), TIMELINE_ABSOLUTE, TIMELINE_ONCE)
					
					fnBufferTxAdd('FN,ON,2')
					WAIT 10
						fnBufferTxAdd('FN,OFF,2')
						
					IF(TIMELINE_ACTIVE(tlScreenFrappeOpen))
					{
						TIMELINE_KILL(tlScreenFrappeOpen)
						
						WAIT 15
						fnBufferTxAdd('FN,ON,2')
						WAIT 25
							fnBufferTxAdd('FN,OFF,2')
					}
				}
			}
			ACTIVE(CHANNEL.CHANNEL == MOTOR_OPEN):
			{
				fnBufferTxAdd('FN,OFF,2')
				
				IF(!TIMELINE_ACTIVE(tlScreenFrappeOpen))
				{
					TIMELINE_CREATE(tlScreenFrappeOpen, ltimesScreen, LENGTH_ARRAY(ltimesScreen), TIMELINE_ABSOLUTE, TIMELINE_ONCE)
					
					fnBufferTxAdd('FN,ON,1')
					WAIT 10
						fnBufferTxAdd('FN,OFF,1')
						
					IF(TIMELINE_ACTIVE(tlScreenFrappeClose))
					{
						TIMELINE_KILL(tlScreenFrappeClose)
						
						WAIT 15
						fnBufferTxAdd('FN,ON,1')
						WAIT 25
							fnBufferTxAdd('FN,OFF,1')
					}
				}
			}
		}
	}
}

CHANNEL_EVENT[VIRTUAL.NUMBER:2:VIRTUAL.SYSTEM, 0]
{
	ON:
	{
		SELECT
		{
			ACTIVE(CHANNEL.CHANNEL == MOTOR_CLOSE):
			{
				fnBufferTxAdd('FN,OFF,3')
				
				IF(!TIMELINE_ACTIVE(tlScreenMoccaClose))
				{
					TIMELINE_CREATE(tlScreenMoccaClose, ltimesScreen,  LENGTH_ARRAY(ltimesScreen), TIMELINE_ABSOLUTE, TIMELINE_ONCE)
					
					fnBufferTxAdd('FN,ON,4')
					WAIT 10
						fnBufferTxAdd('FN,OFF,4')
						
					IF(TIMELINE_ACTIVE(tlScreenMoccaOpen))
					{
						TIMELINE_KILL(tlScreenMoccaOpen)
						
						WAIT 15
							fnBufferTxAdd('FN,ON,4')
						WAIT 25
							fnBufferTxAdd('FN,OFF,4')
					}
				}
			}
			ACTIVE(CHANNEL.CHANNEL == MOTOR_OPEN):
			{
				fnBufferTxAdd('FN,OFF,4')
				
				IF(!TIMELINE_ACTIVE(tlScreenMoccaOpen))
				{
					TIMELINE_CREATE(tlScreenMoccaOpen, ltimesScreen,  LENGTH_ARRAY(ltimesScreen), TIMELINE_ABSOLUTE, TIMELINE_ONCE)
					
					fnBufferTxAdd('FN,ON,3')
					WAIT 10
						fnBufferTxAdd('FN,OFF,3')
						
					IF(TIMELINE_ACTIVE(tlScreenMoccaClose))
					{
						TIMELINE_KILL(tlScreenMoccaClose)
						
						WAIT 15
							fnBufferTxAdd('FN,ON,3')
						WAIT 25
							fnBufferTxAdd('FN,OFF,3')
					}
				}
			}
		}
	}
}

