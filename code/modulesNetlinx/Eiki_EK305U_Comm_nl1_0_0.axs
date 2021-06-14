MODULE_NAME='Eiki_EK305U_Comm_nl1_0_0' (DEV VIRTUAL, DEV REAL)
(***********************************************************)
(*  FILE CREATED ON: 05/11/2017  AT: 15:43:05              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 06/01/2017  AT: 21:55:42        *)
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

STRUCT __EIKI_BUFFER {
	CHAR rx[1000]
	CHAR tx[100]
}

STRUCT __EIKI_STATUS {
	CHAR isOnline[5]
	CHAR lastTxCommand[10]
	INTEGER isLampPower
	INTEGER isWarming
	INTEGER isCooling
	INTEGER lampTime
	INTEGER pictureFreeze
	INTEGER pictureMute
}

STRUCT __SETTINGS_RS {
	CHAR baud[10]
}

STRUCT __EIKI_SETTINGS {
	__SETTINGS_RS rs
}

STRUCTURE __EIKI
{
	__EIKI_SETTINGS settings
	__EIKI_STATUS status
	__EIKI_BUFFER buffer
}

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

VOLATILE __EIKI eiki

VOLATILE LONG ltimesMaintainConnection[] = {10000};
VOLATILE LONG ltimesBufferRx[] = {100};
VOLATILE LONG ltimesBufferTx[] = {200};
VOLATILE LONG ltimesSetOffline[] = {15000};

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)
DEFINE_FUNCTION eikiDebug(CHAR message[])
{
	SEND_STRING 0,"'############### EIKI ##############'";
	SEND_STRING 0,"'TRACE: ',message";
	SEND_STRING 0,"'############### EIKI ##############'";
}

DEFINE_FUNCTION eikiBufferTxAdd(CHAR message[])
{
	eiki.buffer.tx = "eiki.buffer.tx, message, $0D"
}

DEFINE_FUNCTION setControlMethod()
{
	IF(REAL.NUMBER <> 0)
		eiki.settings.rs.baud = '19200';

	TIMELINE_CREATE(tlMaintainConnection, ltimesMaintainConnection, LENGTH_ARRAY(ltimesMaintainConnection), TIMELINE_ABSOLUTE, TIMELINE_REPEAT)
	TIMELINE_CREATE(tlBufferRx, ltimesBufferRx, LENGTH_ARRAY(ltimesBufferRx), TIMELINE_ABSOLUTE, TIMELINE_REPEAT)
	TIMELINE_CREATE(tlBufferTx, ltimesBufferTx, LENGTH_ARRAY(ltimesBufferTx), TIMELINE_ABSOLUTE, TIMELINE_REPEAT)

	eikiDebug("'setControlMethod --- control method is being set to [rs232]'")
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
	LOCAL_VAR INTEGER iteration

	eikiBufferTxAdd('CR0');
	iteration = iteration + 1;

	IF(iteration == 10)
	{
		iteration = 0
		eikiBufferTxAdd('CR3');
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
		eiki.status.isOnline = 'true'

		SEND_COMMAND REAL,"'SET BAUD ', eiki.settings.rs.baud, ',8,N,1 485 DISABLE'"
		SEND_COMMAND REAL,"'HSOFF'"
		SEND_COMMAND REAL,"'RXON'"
	}
	OFFLINE:
	{
		eiki.status.isOnline = 'false';
		OFF[VIRTUAL, DEVICE_COMMUNICATING]
		OFF[VIRTUAL, DATA_INITIALIZED]
		OFF[VIRTUAL, POWER_FB]
	}
	STRING:
	{
		eiki.buffer.rx = "eiki.buffer.rx, DATA.TEXT"
		eikiDebug("'RX STRING: [', DATA.TEXT, ']' ")
	}
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														    						     			 bufferTx
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
TIMELINE_EVENT[tlBufferTx]
{
	STACK_VAR CHAR tempBufferTx[100]

	IF(eiki.status.isOnline == 'true')
	{
		IF(FIND_STRING(eiki.buffer.tx, "$0D", 1))
		{
			tempBufferTx = REMOVE_STRING(eiki.buffer.tx, "$0D", 1)
			SEND_STRING REAL, tempBufferTx
			eikiDebug("'SEND MESSAGE --- [', tempBufferTx, ']'")
			eiki.status.lastTxCommand = tempBufferTx
			SET_LENGTH_STRING(eiki.status.lastTxCommand, LENGTH_STRING(eiki.status.lastTxCommand) - 1)
		}
	}
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														    						     			 bufferRx
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
TIMELINE_EVENT[tlBufferRx]
{
	STACK_VAR CHAR temporaryBufferRx[100]
	STACK_VAR INTEGER doUpdate

	IF(FIND_STRING(eiki.buffer.rx, "$0D", 1))
	{
		ON[VIRTUAL, DATA_INITIALIZED]
		ON[VIRTUAL, POWER_FB]

		temporaryBufferRx = REMOVE_STRING(eiki.buffer.rx, "$0D", 1)

		//maintain communication between amx and ecler
		IF(eiki.status.lastTxCommand == 'CR0')	//status info
		{
			SELECT
			{
				ACTIVE(FIND_STRING(temporaryBufferRx, "'00',$0D", 1)):
				{
					doUpdate = TRUE;
					ON[VIRTUAL, LAMP_POWER_FB]
					eiki.status.isLampPower = TRUE;
				}
				ACTIVE(FIND_STRING(temporaryBufferRx, "'80',$0D", 1)):
				{
					doUpdate = TRUE;
					OFF[VIRTUAL, LAMP_POWER_FB]
					eiki.status.isLampPower = FALSE;

					OFF[VIRTUAL, PIC_FREEZE_FB]
					OFF[VIRTUAL, PIC_MUTE_FB]
				}

				//"40":Countdown in process
				//"20":Cooling Down in process
				//"10":Power Failure
				//"28":Cooling Down in process due to Temperature Anomaly
				//"88":Coming back after Temperature Anomaly
				//"24":Power Management cooling
				//"04":suspend status(Power management Ready)
				//"21":Cooling Down in process after lamp off
				//"81":Standby after Cooling Down process due to lamp off
				ACTIVE(FIND_STRING(temporaryBufferRx, "'40',$0D", 1)):	doUpdate = TRUE;
				ACTIVE(FIND_STRING(temporaryBufferRx, "'20',$0D", 1)):	doUpdate = TRUE;
				ACTIVE(FIND_STRING(temporaryBufferRx, "'10',$0D", 1)):	doUpdate = TRUE;
				ACTIVE(FIND_STRING(temporaryBufferRx, "'28',$0D", 1)):	doUpdate = TRUE;
				ACTIVE(FIND_STRING(temporaryBufferRx, "'88',$0D", 1)):	doUpdate = TRUE;
				ACTIVE(FIND_STRING(temporaryBufferRx, "'24',$0D", 1)):	doUpdate = TRUE;
				ACTIVE(FIND_STRING(temporaryBufferRx, "'04',$0D", 1)):	doUpdate = TRUE;
				ACTIVE(FIND_STRING(temporaryBufferRx, "'21',$0D", 1)):	doUpdate = TRUE;
				ACTIVE(FIND_STRING(temporaryBufferRx, "'81',$0D", 1)):	doUpdate = TRUE;
			}

			IF(doUpdate)
			{
				doUpdate = FALSE;
				ON[VIRTUAL, DEVICE_COMMUNICATING]

				IF(TIMELINE_ACTIVE(tlSetOffline))
					TIMELINE_SET(tlSetOffline,0)
				ELSE
					TIMELINE_CREATE(tlSetOffline,ltimesSetOffline,LENGTH_ARRAY(ltimesSetOffline),TIMELINE_ABSOLUTE,TIMELINE_ONCE)
			}
		}

		ELSE IF(eiki.status.lastTxCommand == 'CR3')
		{
			eiki.status.lampTime = ATOI(temporaryBufferRx);
			SEND_COMMAND VIRTUAL, "'LAMPTIME-', ITOA(eiki.status.lampTime)";
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

			eiki.buffer.tx = '';
			IF(TIMELINE_ACTIVE(tlBufferTx))
			{
				TIMELINE_SET(tlBufferTx,0)
				TIMELINE_PAUSE(tlBufferTx)
				WAIT 20
					TIMELINE_RESTART(tlBufferTx)
			}

			eiki.buffer.rx = '';
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
			eikiBufferTxAdd(DATA.TEXT)
		}
	}
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														    					 				 powerControl
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
CHANNEL_EVENT[VIRTUAL, 0]
{
	ON:
	{
		SWITCH(CHANNEL.CHANNEL)
		{
			CASE PWR_ON:
			{
				eikiBufferTxAdd('C00');
				IF(eiki.status.isLampPower == FALSE)
				{
					eiki.status.isWarming = TRUE
					ON[VIRTUAL,LAMP_WARMING_FB]
					CANCEL_WAIT 'warming'
					WAIT 900 'warming'
					{
						eiki.status.isWarming = FALSE
						OFF[VIRTUAL,LAMP_WARMING_FB]
					}
				}

				eiki.status.isLampPower = TRUE;
				ON[VIRTUAL, LAMP_POWER_FB]
			}

			CASE PWR_OFF:
			{
				eikiBufferTxAdd('C01');
				IF(eiki.status.isLampPower == TRUE)
				{
					eiki.status.isCooling = TRUE
					ON[VIRTUAL,LAMP_COOLING_FB]
					CANCEL_WAIT 'cooling'
					WAIT 1200 'cooling'
					{
						eiki.status.isCooling = FALSE
						OFF[VIRTUAL,LAMP_COOLING_FB]
					}
				}

				eiki.status.isLampPower = FALSE;
				OFF[VIRTUAL, LAMP_POWER_FB]
			}
		}
	}
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														    					 				pictureFreeze
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
CHANNEL_EVENT[VIRTUAL, PIC_FREEZE_ON]
{
	ON: 	eikiBufferTxAdd('C43');
	OFF: 	eikiBufferTxAdd('C44');
}

CHANNEL_EVENT[VIRTUAL, PIC_MUTE_ON]
{
	ON:		eikiBufferTxAdd('C0D');
	OFF:	eikiBufferTxAdd('C0E');
}