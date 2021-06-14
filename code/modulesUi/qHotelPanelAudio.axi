PROGRAM_NAME='qHotelPanelAudio'
(***********************************************************)
(*  FILE CREATED ON: 05/10/2017  AT: 16:50:48              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 06/01/2017  AT: 21:07:10        *)
(***********************************************************)
#INCLUDE 'SNAPI'
#INCLUDE 'CHAPI'

#INCLUDE 'qHotelDeviceDefinitions'
#INCLUDE 'qHotelConstantDefinitions'
#INCLUDE 'qHotelStructureDefinitions'
#INCLUDE 'qHotelVariableDefinitions'

#INCLUDE 'xml_string_control'
#INCLUDE 'amx_panel_control_v2'
#INCLUDE 'nx_string_control'

(***********************************************************)
(*          CONNECT LEVEL DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONNECT_LEVEL

//(vdvDbx, 301, dvPanelVolumeFrappe, 1, dvPanelVolumeMocca, 1)
//(vdvDbx, 302, dvPanelVolumeFrappe, 2, dvPanelVolumeMocca, 2)
(***********************************************************)
(*                 STARTUP CODE GOES BELOW                 *)
(***********************************************************)
DEFINE_START

//SEND_LEVEL vdvDbx, 301, defaultMicrophoneGain
//SEND_LEVEL vdvDbx, 302, defaultMicrophoneGain
(***********************************************************)
(*                  THE EVENTS GO BELOW                    *)
(***********************************************************)
DEFINE_EVENT

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														        deviceCommunicationSettings
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
DATA_EVENT [dvDbx]
{
	ONLINE:
  {
		IF(dbxControlIp)
		{
			q.device.aplifier.status.isInitialized = TRUE;
			q.device.aplifier.status.isCommunicating = TRUE; // This is so if the connection fails it will try to reconnect
		}
	}
  OFFLINE:
  {
		IF(dbxControlIp)
		{
	    q.device.aplifier.status.isInitialized = FALSE;
	    IF (q.device.aplifier.status.isCommunicating)
	    {
				WAIT 30
					IP_CLIENT_OPEN (dvDbx.PORT, q.device.aplifier.settings.ip.address, 3804, IP_TCP);
	    }
		}
	}
	ONERROR:
	{
		IF(dbxControlIp)
		{
	    SWITCH (DATA.NUMBER)
	    {
				// No need to reopen socket in response to following two errors.
				CASE 9: // Socket closed in response to IP_CLIENT_CLOSE.
				CASE 17: // String was sent to a closed socket.
				{
				}
				DEFAULT: // All other errors. May want to retry connection.
				{
					IF (q.device.aplifier.status.isCommunicating)
					{
						WAIT 30
							IP_CLIENT_OPEN (dvDbx.PORT, q.device.aplifier.settings.ip.address, 3804, IP_TCP);
					}
				}
	    }
		}
	}
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														        				   audioLevelUpdate
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
DATA_EVENT[dvPanelVolumeFrappe]
{
	ONLINE:
	{
		WAIT 30
		{
			isPanelOnlineFrappe = TRUE

			SEND_LEVEL dvPanelVolumeFrappe, 11, q.device.aplifier.zone[1].volume
			SEND_LEVEL dvPanelVolumeFrappe, 1, q.device.aplifier.microphone[1].gain
			SEND_LEVEL dvPanelVolumeFrappe, 2, q.device.aplifier.microphone[2].gain
		}
	}
	OFFLINE:
		isPanelOnlineFrappe = FALSE;
}

DATA_EVENT[dvPanelVolumeMocca]
{
	ONLINE:
	{
		WAIT 30
		{
			isPanelOnlineMocca = TRUE

			SEND_LEVEL dvPanelVolumeMocca, 11, q.device.aplifier.zone[2].volume
			SEND_LEVEL dvPanelVolumeMocca, 1, q.device.aplifier.microphone[1].gain
			SEND_LEVEL dvPanelVolumeMocca, 2, q.device.aplifier.microphone[2].gain
		}
	}
	OFFLINE:
		isPanelOnlineMocca = FALSE;
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														        				masterVolumeControl
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
LEVEL_EVENT[dvPanelVolumeFrappe,11]
{
	IF(isPanelOnlineFrappe)
	{
		q.device.aplifier.zone[1].volume = LEVEL.VALUE
		SEND_COMMAND vdvDbx,"'LEVEL=1:O:1:',ITOA(q.device.aplifier.zone[1].volume)"

		IF(q.roomCombined == TRUE)
		{
			q.device.aplifier.zone[2].volume = LEVEL.VALUE
			SEND_COMMAND vdvDbx,"'LEVEL=1:O:2:',ITOA(q.device.aplifier.zone[2].volume)"
		}


		IF(q.device.aplifier.zone[1].mute)
		{
			q.device.aplifier.zone[1].mute = FALSE
			SEND_COMMAND vdvDbx,'MUTE=1:O:1:0'
			IF(q.roomCombined == TRUE)
			{
				q.device.aplifier.zone[2].mute = q.device.aplifier.zone[1].mute
				SEND_COMMAND vdvDbx,'MUTE=1:O:2:0'
			}
		}
	}
}

LEVEL_EVENT[dvPanelVolumeMocca,11]
{
	IF(isPanelOnlineMocca)
	{
		q.device.aplifier.zone[2].volume = LEVEL.VALUE
		SEND_COMMAND vdvDbx,"'LEVEL=1:O:2:',ITOA(q.device.aplifier.zone[2].volume)"

		IF(q.device.aplifier.zone[2].mute)
		{
			q.device.aplifier.zone[2].mute = FALSE
			SEND_COMMAND vdvDbx,'MUTE=1:O:2:0'
		}
	}
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														        				  masterMuteControl
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
BUTTON_EVENT[dvPanelVolumeFrappe,11]
{
	PUSH:
	{
		q.device.aplifier.zone[1].mute = !q.device.aplifier.zone[1].mute

		IF(q.device.aplifier.zone[1].mute)
		{
			SEND_COMMAND vdvDbx,'MUTE=1:O:1:1'
			IF(q.roomCombined == TRUE)
			{
				q.device.aplifier.zone[2].mute = q.device.aplifier.zone[1].mute
				SEND_COMMAND vdvDbx,'MUTE=1:O:2:1'
			}
		}
		ELSE
		{
			SEND_COMMAND vdvDbx,'MUTE=1:O:1:0'
			IF(q.roomCombined == TRUE)
			{
				q.device.aplifier.zone[2].mute = q.device.aplifier.zone[1].mute
				SEND_COMMAND vdvDbx,'MUTE=1:O:2:0'
			}
		}
	}
}

BUTTON_EVENT[dvPanelVolumeMocca,11]
{
	PUSH:
	{
		q.device.aplifier.zone[2].mute = !q.device.aplifier.zone[2].mute

		IF(q.device.aplifier.zone[2].mute)
			SEND_COMMAND vdvDbx,'MUTE=1:O:2:1'
		ELSE
			SEND_COMMAND vdvDbx,'MUTE=1:O:2:0'
	}
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														        				  		feedbackPanel
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
TIMELINE_EVENT[tlPanelFeedback]
{
	[dvPanelVolumeFrappe,11] = q.device.aplifier.zone[1].mute == TRUE
	[dvPanelVolumeMocca,11] = q.device.aplifier.zone[2].mute == TRUE

	[dvPanelVolumeFrappe, 1] = ([vdvAudioSwitcher, 11] == TRUE)
	[dvPanelVolumeFrappe, 2] = ([vdvAudioSwitcher, 21] == TRUE)

	[dvPanelVolumeMocca, 1] = ([vdvAudioSwitcher, 12] == TRUE)
	[dvPanelVolumeMocca, 2] = ([vdvAudioSwitcher, 22] == TRUE)
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														        			microphoneGainControl
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
LEVEL_EVENT[dvPanelVolumeFrappe,1]
{
	IF(isPanelOnlineFrappe)
	{
		q.device.aplifier.microphone[1].gain = LEVEL.VALUE
		SEND_COMMAND vdvDbx,"'MIXERLEVEL=1:I:1:1:',ITOA(q.device.aplifier.microphone[1].gain)"
		
		IF(q.roomCombined)
			SEND_COMMAND vdvDbx,"'MIXERLEVEL=1:I:2:1:',ITOA(q.device.aplifier.microphone[1].gain)"
	}
}

LEVEL_EVENT[dvPanelVolumeFrappe,2]
{
	IF(isPanelOnlineFrappe)
	{
		q.device.aplifier.microphone[2].gain = LEVEL.VALUE
		SEND_COMMAND vdvDbx,"'MIXERLEVEL=1:I:1:2:',ITOA(q.device.aplifier.microphone[2].gain)"
		
		IF(q.roomCombined)
			SEND_COMMAND vdvDbx,"'MIXERLEVEL=1:I:2:2:',ITOA(q.device.aplifier.microphone[2].gain)"
	}
}

LEVEL_EVENT[dvPanelVolumeMocca,1]
{
	IF(isPanelOnlineMocca)
	{
		q.device.aplifier.microphone[1].gain = LEVEL.VALUE
		SEND_COMMAND vdvDbx,"'MIXERLEVEL=1:I:2:1:',ITOA(q.device.aplifier.microphone[1].gain)"
	}
}

LEVEL_EVENT[dvPanelVolumeMocca,2]
{
	IF(isPanelOnlineMocca)
	{
		q.device.aplifier.microphone[2].gain = LEVEL.VALUE
		SEND_COMMAND vdvDbx,"'MIXERLEVEL=1:I:2:2:',ITOA(q.device.aplifier.microphone[2].gain)"
	}
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														        				  		   micControl
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
BUTTON_EVENT[dvPanelVolumeFrappe,0]
{
	PUSH:
	{
		SWITCH(BUTTON.INPUT.CHANNEL)
		{
			CASE 1:
			{
				IF(q.roomCombined)
				{
					IF([vdvAudioSwitcher,11] == TRUE)
						SEND_COMMAND vdvAudioSwitcher, 'MIC_A-OFF,BOTH'
					ELSE
						SEND_COMMAND vdvAudioSwitcher, 'MIC_A-ON,BOTH'
				}
				ELSE
				{
					IF([vdvAudioSwitcher,11] == TRUE)
						SEND_COMMAND vdvAudioSwitcher, 'MIC_A-OFF,FRAPPE'
					ELSE
						SEND_COMMAND vdvAudioSwitcher, 'MIC_A-ON,FRAPPE'
				}
			}

			CASE 2:
			{
				IF(q.roomCombined)
				{
					IF([vdvAudioSwitcher,21] == TRUE)
						SEND_COMMAND vdvAudioSwitcher, 'MIC_B-OFF,BOTH'
					ELSE
						SEND_COMMAND vdvAudioSwitcher, 'MIC_B-ON,BOTH'
				}
				ELSE
				{
					IF([vdvAudioSwitcher,21] == TRUE)
						SEND_COMMAND vdvAudioSwitcher, 'MIC_B-OFF,FRAPPE'
					ELSE
						SEND_COMMAND vdvAudioSwitcher, 'MIC_B-ON,FRAPPE'
				}
			}
		}
	}
}

BUTTON_EVENT[dvPanelVolumeMocca,0]
{
	PUSH:
	{
		SWITCH(BUTTON.INPUT.CHANNEL)
		{
			CASE 1:
			{
				IF([vdvAudioSwitcher,12] == TRUE)
					SEND_COMMAND vdvAudioSwitcher, 'MIC_A-OFF,MOCCA'
				ELSE
					SEND_COMMAND vdvAudioSwitcher, 'MIC_A-ON,MOCCA'
			}

			CASE 2:
			{
				IF([vdvAudioSwitcher,22] == TRUE)
					SEND_COMMAND vdvAudioSwitcher, 'MIC_B-OFF,MOCCA'
				ELSE
					SEND_COMMAND vdvAudioSwitcher, 'MIC_B-ON,MOCCA'
			}
		}
	}
}