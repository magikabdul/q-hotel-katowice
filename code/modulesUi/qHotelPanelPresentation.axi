PROGRAM_NAME='qHotelPanelPresentation'
(***********************************************************)
(*  FILE CREATED ON: 05/10/2017  AT: 16:50:31              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 07/25/2017  AT: 19:11:16        *)
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
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

([dvPanelPresentationFrappe,10]..[dvPanelPresentationFrappe,14])
([dvPanelPresentationFrappe,30]..[dvPanelPresentationFrappe,34])

([dvPanelPresentationMocca,30]..[dvPanelPresentationMocca,34])
(***********************************************************)
(*                 STARTUP CODE GOES BELOW                 *)
(***********************************************************)
DEFINE_START

(***********************************************************)
(*                  THE EVENTS GO BELOW                    *)
(***********************************************************)
DEFINE_EVENT

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														    	presentationControlRoomFrappe
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
BUTTON_EVENT[dvPanelPresentationFrappe,0]
{
	PUSH:
	{
		SWITCH(BUTTON.INPUT.CHANNEL)
		{
			CASE 10:	//off projector room frappe
			{
				PULSE[vdvProjectorFrappe, PWR_OFF]
				PULSE[vdvScreenFrappe, MOTOR_CLOSE]

				SEND_LEVEL dvPanelVolumeFrappe, 11, 0

				IF(q.roomCombined == TRUE)
					SEND_COMMAND vdvAudioSwitcher, 'INPUT-OFF,BOTH'
				ELSE
					SEND_COMMAND vdvAudioSwitcher, 'INPUT-OFF,FRAPPE'

				ON[dvPanelPresentationFrappe,BUTTON.INPUT.CHANNEL]
			}

			CASE 11:
			{
				//IF(![vdvProjectorFrappe, LAMP_POWER_FB])
					PULSE[vdvScreenFrappe, MOTOR_OPEN]

				PULSE[vdvProjectorFrappe, PWR_ON]

				SEND_COMMAND vdvVideoSwitcher, 'INPUT-FRAPPE_TABLE,FRAPPE'

				SEND_LEVEL dvPanelVolumeFrappe, 11, defaultSystemVolume

				IF(q.roomCombined == TRUE)
					SEND_COMMAND vdvAudioSwitcher, 'INPUT-FRAPPE,BOTH'
				ELSE
					SEND_COMMAND vdvAudioSwitcher, 'INPUT-FRAPPE,FRAPPE'

				ON[dvPanelPresentationFrappe,BUTTON.INPUT.CHANNEL]
			}

			CASE 12:
			{
				//IF(![vdvProjectorFrappe, LAMP_POWER_FB])
					PULSE[vdvScreenFrappe, MOTOR_OPEN]

				PULSE[vdvProjectorFrappe, PWR_ON]

				SEND_COMMAND vdvVideoSwitcher, 'INPUT-FRAPPE_TUNER,FRAPPE'

				SEND_LEVEL dvPanelVolumeFrappe, 11, defaultSystemVolume

				IF(q.roomCombined == TRUE)
					SEND_COMMAND vdvAudioSwitcher, 'INPUT-FRAPPE,BOTH'
				ELSE
					SEND_COMMAND vdvAudioSwitcher, 'INPUT-FRAPPE,FRAPPE'

				ON[dvPanelPresentationFrappe,BUTTON.INPUT.CHANNEL]
			}

			CASE 13:
			{
				//IF(![vdvProjectorFrappe, LAMP_POWER_FB])
					PULSE[vdvScreenFrappe, MOTOR_OPEN]

				PULSE[vdvProjectorFrappe, PWR_ON]

				SEND_COMMAND vdvVideoSwitcher, 'INPUT-MOCCA_TABLE,FRAPPE'

				SEND_LEVEL dvPanelVolumeFrappe, 11, defaultSystemVolume

				SEND_COMMAND vdvAudioSwitcher, 'INPUT-MOCCA,BOTH'

				ON[dvPanelPresentationFrappe,BUTTON.INPUT.CHANNEL]
			}

			CASE 14:
			{
				//IF(![vdvProjectorFrappe, LAMP_POWER_FB])
					PULSE[vdvScreenFrappe, MOTOR_OPEN]

				PULSE[vdvProjectorFrappe, PWR_ON]

				SEND_COMMAND vdvVideoSwitcher, 'INPUT-MOCCA_TUNER,FRAPPE'

				SEND_LEVEL dvPanelVolumeFrappe, 11, defaultSystemVolume

				SEND_COMMAND vdvAudioSwitcher, 'INPUT-MOCCA,BOTH'

				ON[dvPanelPresentationFrappe,BUTTON.INPUT.CHANNEL]
			}


			CASE 30:	//off projector room mocca
			{
				PULSE[vdvProjectorMocca, PWR_OFF]
				PULSE[vdvScreenMocca, MOTOR_CLOSE]

				SEND_LEVEL dvPanelVolumeFrappe, 11, 0

				IF([vdvProjectorFrappe, LAMP_POWER_FB] == FALSE)
					SEND_COMMAND vdvAudioSwitcher, 'INPUT-OFF,BOTH'

				ON[dvPanelPresentationFrappe,BUTTON.INPUT.CHANNEL]
			}

			CASE 31:
			{
				//IF(![vdvProjectorMocca, LAMP_POWER_FB])
					PULSE[vdvScreenMocca, MOTOR_OPEN]

				PULSE[vdvProjectorMocca, PWR_ON]

				SEND_COMMAND vdvVideoSwitcher, 'INPUT-MOCCA_TABLE,MOCCA'

				SEND_LEVEL dvPanelVolumeFrappe, 11, defaultSystemVolume

				SEND_COMMAND vdvAudioSwitcher, 'INPUT-MOCCA,BOTH'

				ON[dvPanelPresentationFrappe,BUTTON.INPUT.CHANNEL]
			}

			CASE 32:
			{
				//IF(![vdvProjectorMocca, LAMP_POWER_FB])
					PULSE[vdvScreenMocca, MOTOR_OPEN]

				PULSE[vdvProjectorMocca, PWR_ON]

				SEND_COMMAND vdvVideoSwitcher, 'INPUT-MOCCA_TUNER,MOCCA'

				SEND_LEVEL dvPanelVolumeFrappe, 11, defaultSystemVolume

				SEND_COMMAND vdvAudioSwitcher, 'INPUT-MOCCA,BOTH'

				ON[dvPanelPresentationFrappe,BUTTON.INPUT.CHANNEL]
			}

			CASE 33:
			{
				//IF(![vdvProjectorMocca, LAMP_POWER_FB])
					PULSE[vdvScreenMocca, MOTOR_OPEN]

				PULSE[vdvProjectorMocca, PWR_ON]

				SEND_COMMAND vdvVideoSwitcher, 'INPUT-FRAPPE_TABLE,MOCCA'

				SEND_LEVEL dvPanelVolumeFrappe, 11, defaultSystemVolume

				SEND_COMMAND vdvAudioSwitcher, 'INPUT-FRAPPE,BOTH'

				ON[dvPanelPresentationFrappe,BUTTON.INPUT.CHANNEL]
			}

			CASE 34:
			{
				//IF(![vdvProjectorMocca, LAMP_POWER_FB])
					PULSE[vdvScreenMocca, MOTOR_OPEN]

				PULSE[vdvProjectorMocca, PWR_ON]

				SEND_COMMAND vdvVideoSwitcher, 'INPUT-FRAPPE_TUNER,MOCCA'

				SEND_LEVEL dvPanelVolumeFrappe, 11, defaultSystemVolume

				SEND_COMMAND vdvAudioSwitcher, 'INPUT-FRAPPE,BOTH'

				ON[dvPanelPresentationFrappe,BUTTON.INPUT.CHANNEL]
			}
		}
	}
}

BUTTON_EVENT[dvPanelPresentationMocca,0]
{
	PUSH:
	{
		SWITCH(BUTTON.INPUT.CHANNEL)
		{
			CASE 30:	//off projector room mocca
			{
				PULSE[vdvProjectorMocca, PWR_OFF]
				PULSE[vdvScreenMocca, MOTOR_CLOSE]

				SEND_LEVEL dvPanelVolumeMocca, 11, 0

				SEND_COMMAND vdvAudioSwitcher, 'INPUT-OFF,MOCCA'

				ON[dvPanelPresentationMocca,BUTTON.INPUT.CHANNEL]
			}

			CASE 31:
			{
				//IF(![vdvProjectorMocca, LAMP_POWER_FB])
					PULSE[vdvScreenMocca, MOTOR_OPEN]

				PULSE[vdvProjectorMocca, PWR_ON]

				SEND_COMMAND vdvVideoSwitcher, 'INPUT-MOCCA_TABLE,MOCCA'

				SEND_LEVEL dvPanelVolumeMocca, 11, defaultSystemVolume

				SEND_COMMAND vdvAudioSwitcher, 'INPUT-MOCCA,MOCCA'

				ON[dvPanelPresentationMocca,BUTTON.INPUT.CHANNEL]
			}

			CASE 32:
			{
				//IF(![vdvProjectorMocca, LAMP_POWER_FB])
					PULSE[vdvScreenMocca, MOTOR_OPEN]

				PULSE[vdvProjectorMocca, PWR_ON]

				SEND_COMMAND vdvVideoSwitcher, 'INPUT-MOCCA_TUNER,MOCCA'

				SEND_LEVEL dvPanelVolumeMocca, 11, defaultSystemVolume

				SEND_COMMAND vdvAudioSwitcher, 'INPUT-MOCCA,MOCCA'

				ON[dvPanelPresentationMocca,BUTTON.INPUT.CHANNEL]
			}
		}
	}
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														    							        systemOff
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
BUTTON_EVENT[dvPanelMainFrappe, PWR_OFF]
{
	PUSH:
	{
		PULSE[vdvProjectorFrappe, PWR_OFF]
		PULSE[vdvScreenFrappe, MOTOR_CLOSE]

		SEND_LEVEL dvPanelVolumeFrappe, 11, 0

		DO_PUSH(dvPanelLightFrappe, 12)

		IF(q.roomCombined)
		{
			SEND_COMMAND vdvAudioSwitcher, 'INPUT-OFF,BOTH'
			SEND_COMMAND vdvAudioSwitcher, 'MIC_A-OFF,BOTH'
			SEND_COMMAND vdvAudioSwitcher, 'MIC_B-OFF,BOTH'

			ON[dvPanelPresentationFrappe, 10]
			ON[dvPanelPresentationFrappe, 30]
		}
		ELSE
		{
			SEND_COMMAND vdvAudioSwitcher, 'INPUT-OFF,FRAPPE'
			SEND_COMMAND vdvAudioSwitcher, 'MIC_A-OFF,FRAPPE'
			SEND_COMMAND vdvAudioSwitcher, 'MIC_B-OFF,FRAPPE'

			ON[dvPanelPresentationFrappe, 10]
		}


		IF(q.roomCombined)
		{
			PULSE[vdvProjectorMocca, PWR_OFF]
			PULSE[vdvScreenMocca, MOTOR_CLOSE]

			SEND_LEVEL dvPanelVolumeMocca, 11, 0
		}
	}
}

BUTTON_EVENT[dvPanelMainMocca, PWR_OFF]
{
	PUSH:
	{
		PULSE[vdvProjectorMocca, PWR_OFF]
		PULSE[vdvScreenMocca, MOTOR_CLOSE]

		SEND_LEVEL dvPanelVolumeMocca, 11, 0

		DO_PUSH(dvPanelLightMocca, 12)

		SEND_COMMAND vdvAudioSwitcher, 'INPUT-OFF,MOCCA'
		SEND_COMMAND vdvAudioSwitcher, 'MIC_A-OFF,MOCCA'
		SEND_COMMAND vdvAudioSwitcher, 'MIC_B-OFF,MOCCA'

		ON[dvPanelPresentationMocca, 30]
	}
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														    							projectorFeedback
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
TIMELINE_EVENT[tlPanelFeedback]
{
	IF([vdvProjectorFrappe, LAMP_WARMING_FB])
		tpButtonShow(dvPanelsPresentationFrappe, 17)
	ELSE
		tpButtonHide(dvPanelsPresentationFrappe, 17)

	IF([vdvProjectorFrappe, LAMP_COOLING_FB])
	{
		IF(q.roomCombined)
			tpButtonShow(dvPanelsPresentationFrappe, 19)
		ELSE
			tpButtonShow(dvPanelsPresentationFrappe, 18)
	}
	ELSE
	{
		tpButtonHide(dvPanelsPresentationFrappe, 19)
		tpButtonHide(dvPanelsPresentationFrappe, 18)
	}

	IF([vdvProjectorMocca, LAMP_WARMING_FB])
	{
		tpButtonShow(dvPanelsPresentationFrappe, 37)
		tpButtonShow(dvPanelsPresentationMocca, 37)
	}
	ELSE
	{
		tpButtonHide(dvPanelsPresentationFrappe, 37)
		tpButtonHide(dvPanelsPresentationMocca, 37)
	}

	IF([vdvProjectorMocca, LAMP_COOLING_FB])
	{
		tpButtonShow(dvPanelsPresentationMocca, 38)

		IF(q.roomCombined)
			tpButtonShow(dvPanelsPresentationFrappe, 39)
		ELSE
			tpButtonShow(dvPanelsPresentationFrappe, 38)
	}
	ELSE
	{
		tpButtonHide(dvPanelsPresentationMocca, 38)

		tpButtonHide(dvPanelsPresentationFrappe, 39)
		tpButtonHide(dvPanelsPresentationFrappe, 38)
	}
}

DATA_EVENT[vdvProjectorFrappe]
{
	COMMAND:
	{
		IF(FIND_STRING(DATA.TEXT, 'LAMPTIME-', 1))
		{
			REMOVE_STRING(DATA.TEXT, 'LAMPTIME-', 1)
			tpButtonText(dvPanelsPresentationFrappe, 15, "DATA.TEXT, ' h'")
		}
	}
}

DATA_EVENT[vdvProjectorMocca]
{
	COMMAND:
	{
		IF(FIND_STRING(DATA.TEXT, 'LAMPTIME-', 1))
		{
			REMOVE_STRING(DATA.TEXT, 'LAMPTIME-', 1)
			tpButtonText(dvPanelsPresentationFrappe, 35, "DATA.TEXT, ' h'")
			tpButtonText(dvPanelsPresentationMocca, 35, "DATA.TEXT, ' h'")
		}
	}
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														    						picture freeze/mute
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
BUTTON_EVENT[dvPanelPresentationFrappe, 15]
{
	PUSH:
	{
		IF([vdvProjectorFrappe, PIC_MUTE_FB])
			OFF[vdvProjectorFrappe, PIC_MUTE_ON]
		ELSE
			ON[vdvProjectorFrappe, PIC_MUTE_ON]
	}
}

BUTTON_EVENT[dvPanelPresentationFrappe, 16]
{
	PUSH:
	{
		IF([vdvProjectorFrappe, PIC_FREEZE_FB])
			OFF[vdvProjectorFrappe, PIC_FREEZE_ON]
		ELSE
			ON[vdvProjectorFrappe, PIC_FREEZE_ON]
	}
}

BUTTON_EVENT[dvPanelsPresentation, 35]
{
	PUSH:
	{
		IF([vdvProjectorMocca, PIC_MUTE_FB])
			OFF[vdvProjectorMocca, PIC_MUTE_ON]
		ELSE
			ON[vdvProjectorMocca, PIC_MUTE_ON]
	}
}

BUTTON_EVENT[dvPanelsPresentation, 36]
{
	PUSH:
	{
		IF([vdvProjectorMocca, PIC_FREEZE_FB])
			OFF[vdvProjectorMocca, PIC_FREEZE_ON]
		ELSE
			ON[vdvProjectorMocca, PIC_FREEZE_ON]
	}
}

CHANNEL_EVENT[vdvProjectorFrappe, PIC_MUTE_FB]
{
	ON: 	ON[dvPanelsPresentation, 15]
	OFF: 	OFF[dvPanelsPresentation, 15]
}

CHANNEL_EVENT[vdvProjectorFrappe, PIC_FREEZE_FB]
{
	ON: 	ON[dvPanelsPresentation, 16]
	OFF: 	OFF[dvPanelsPresentation, 16]
}

CHANNEL_EVENT[vdvProjectorMocca, PIC_MUTE_FB]
{
	ON: 	ON[dvPanelsPresentation, 35]
	OFF: 	OFF[dvPanelsPresentation, 35]
}

CHANNEL_EVENT[vdvProjectorMocca, PIC_FREEZE_FB]
{
	ON: 	ON[dvPanelsPresentation, 36]
	OFF: 	OFF[dvPanelsPresentation, 36]
}