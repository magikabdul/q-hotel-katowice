MODULE_NAME='Helvar_P905_Comm_nl1_0_0' (DEV VIRTUAL, DEV REAL)
(***********************************************************)
(*  FILE CREATED ON: 05/11/2017  AT: 17:48:10              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 05/11/2017  AT: 23:00:57        *)
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
(***********************************************************)
(*              STRUCTURE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

STRUCT __HELVAR_BUFFER {
	CHAR rx[1000]
	CHAR tx[100]
}

STRUCT __HELVAR_STATUS {
	CHAR isOnline[5]
}

STRUCT __SETTINGS_IP {
	CHAR address[15]
	LONG port
}

STRUCT __HELVAR_SETTINGS {
	CHAR contrlMethod[2]
	__SETTINGS_IP ip
}

STRUCTURE __HELVAR
{
	__HELVAR_SETTINGS settings
	__HELVAR_STATUS status
	__HELVAR_BUFFER buffer
}

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

VOLATILE __HELVAR helvar

VOLATILE LONG ltimesMaintainConnection[] = {10000};
VOLATILE LONG ltimesBufferRx[] = {100};
VOLATILE LONG ltimesBufferTx[] = {200};
VOLATILE LONG ltimesSetOffline[] = {15000};

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)
DEFINE_FUNCTION fnDebug(CHAR message[])
{
	SEND_STRING 0,"'############### HELVAR P905 ##############'";
	SEND_STRING 0,"'TRACE: ',message";
	SEND_STRING 0,"'############### HELVAR P905 ##############'";
}

DEFINE_FUNCTION fnBufferTxAdd(CHAR message[])
{
	helvar.buffer.tx = "helvar.buffer.tx, message"
}

DEFINE_FUNCTION setControlMethod()
{
	helvar.settings.contrlMethod = 'ip';
	helvar.settings.ip.port = 50000;

	helvar.status.isOnline = 'false';

	TIMELINE_CREATE(tlMaintainConnection, ltimesMaintainConnection, LENGTH_ARRAY(ltimesMaintainConnection), TIMELINE_ABSOLUTE, TIMELINE_REPEAT)
	TIMELINE_CREATE(tlBufferRx, ltimesBufferRx, LENGTH_ARRAY(ltimesBufferRx), TIMELINE_ABSOLUTE, TIMELINE_REPEAT)
	TIMELINE_CREATE(tlBufferTx, ltimesBufferTx, LENGTH_ARRAY(ltimesBufferTx), TIMELINE_ABSOLUTE, TIMELINE_REPEAT)

	fnDebug("'setControlMethod --- control method is being set to [' , helvar.settings.contrlMethod, ']'")
}

DEFINE_FUNCTION doClientConnect()
{
	STACK_VAR SLONG result

	IF(helvar.status.isOnline <> 'true')
	{
		fnDebug("'doClientConnect --- attempting connection to ', helvar.settings.ip.address, ':', ITOA(helvar.settings.ip.port) , '...'")

		result = IP_CLIENT_OPEN(REAL.PORT ,helvar.settings.ip.address, helvar.settings.ip.port, IP_TCP)

		IF(result)
		{
			SELECT
			{
				ACTIVE(result == 1):	fnDebug("'doClientConnect --- invalid address [', helvar.settings.ip.address, ']'")
				ACTIVE(result == 2):	fnDebug("'doClientConnect --- invalid port [', ITOA(helvar.settings.ip.port), ']'")
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

//SET_VIRTUAL_PORT_COUNT(VIRTUAL, 4)

setControlMethod();

DEFINE_EVENT

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														    						 maintainConnection
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
TIMELINE_EVENT[tlMaintainConnection]
{
	IF(helvar.status.isOnline == 'false')
	{
		IF(LENGTH_STRING(helvar.settings.ip.address) > 0)
		{
			doClientConnect();
		}
	}
}

TIMELINE_EVENT[tlSetOffline]
{
	IF(helvar.settings.contrlMethod == 'ip')
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
		IF(helvar.settings.contrlMethod == 'ip')
		{
			helvar.status.isOnline = 'true';
			fnDebug("'ONLINE --- System connected to device IP: [', helvar.settings.ip.address, ']'")
			ON[VIRTUAL, DATA_INITIALIZED]
		}
	}
	OFFLINE:
	{
		IF(helvar.settings.contrlMethod == 'ip')
			IP_CLIENT_CLOSE(REAL.PORT);

		helvar.status.isOnline = 'false';
		OFF[VIRTUAL, DEVICE_COMMUNICATING]
		OFF[VIRTUAL, DATA_INITIALIZED]
		OFF[VIRTUAL, POWER_FB]
	}
	STRING:
	{
		helvar.buffer.rx = "helvar.buffer.rx, DATA.TEXT"
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
				helvar.settings.ip.address = DATA.TEXT
			}
			ELSE IF(FIND_STRING(DATA.TEXT, 'IP_Port,', 1))
			{
				REMOVE_STRING(DATA.TEXT, 'IP_Port,', 1)
				helvar.settings.ip.port = ATOI(DATA.TEXT)
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

	IF(helvar.status.isOnline == 'true')
	{
		IF(FIND_STRING(helvar.buffer.tx, '#', 1))
		{
			tempBufferTx = REMOVE_STRING(helvar.buffer.tx, '#', 1)
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

			helvar.buffer.tx = '';
			IF(TIMELINE_ACTIVE(tlBufferTx))
			{
				TIMELINE_SET(tlBufferTx,0)
				TIMELINE_PAUSE(tlBufferTx)
				WAIT 20
					TIMELINE_RESTART(tlBufferTx)
			}

			helvar.buffer.rx = '';
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