PROGRAM_NAME='qHotelPanelMain'
(***********************************************************)
(*  FILE CREATED ON: 05/10/2017  AT: 16:50:16              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 05/12/2017  AT: 00:05:07        *)
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
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

DEFINE_FUNCTION setStartingPanelState()
{
	tpPopupHideAll(dvPanelsMain)
	tpPageShow(dvPanelsMain, '00_LOGO')
	tpPopupShow(dvPanelsMain, 'menuBottom')
}

(***********************************************************)
(*                 STARTUP CODE GOES BELOW                 *)
(***********************************************************)
DEFINE_START

TIMELINE_CREATE(tlPanelFeedback, ltimesPanelFeedback, LENGTH_ARRAY(ltimesPanelFeedback), TIMELINE_ABSOLUTE, TIMELINE_REPEAT)

setStartingPanelState();
(***********************************************************)
(*                  THE EVENTS GO BELOW                    *)
(***********************************************************)
DEFINE_EVENT

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														        								panelStatus
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
DATA_EVENT[dvPanelMainFrappe]
{
	ONLINE:
	{
		IF(q.roomCombined == TRUE)
		{
			//room description
			tpButtonUnicode(dvPanelsMainFrappe, 101, '00530041004C004500200050004F014101040043005A004F004E00450020002D00200047014100D30057004E0059002000500041004E0045004C002000530054004500520055004A010400430059')

			//show sources room mocca
			tpButtonShow(dvPanelsMainFrappe, 102)
			tpButtonUnicode(dvPanelsMainFrappe, 103, '00500052005A0045014101040043005A0045004E00490045002000530041004C0049')
			tpButtonText(dvPanelsMainFrappe, 104, 'ZMIANA TUNERA TELEWIZYJNEGO')
			tpButtonUnicode(dvPanelsMainFrappe, 105, '005A004D00490041004E00410020005300540052004F004E0059002000570059015A0057004900450054004C0041004E004900410020005000520045005A0045004E005400410043004A0049')
		}
		ELSE
		{
			//room description
			tpButtonText(dvPanelsMainFrappe, 101, 'SALA FRAPPE')

			//hide sources room mocca
			tpButtonHide(dvPanelsMainFrappe, 102)
			tpButtonUnicode(dvPanelsMainFrappe, 103, '')
			tpButtonText(dvPanelsMainFrappe, 104, '')
			tpButtonUnicode(dvPanelsMainFrappe, 105, '')
		}
	}
}

DATA_EVENT[dvPanelMainMocca]
{
	ONLINE:
	{
		IF(q.roomCombined == TRUE)
		{
			tpPopupShow(dvPanelsMainMocca, 'lockPanel')
		}
		ELSE
		{
			tpPopupHide(dvPanelsMainMocca, 'lockPanel')

			//room description
			tpButtonText(dvPanelsMainMocca, 101, 'SALA MOCCA')

			//show sources room mocca
			tpButtonHide(dvPanelsMainMocca, 102)
			tpButtonUnicode(dvPanelsMainMocca, 103, '')
			tpButtonText(dvPanelsMainMocca, 104, '')
			tpButtonUnicode(dvPanelsMainMocca, 106, '')
		}
	}
}


//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														        								   feedback
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
TIMELINE_EVENT[tlPanelFeedback]
{
	[dvPanelsMain,100] = q.roomCombined == TRUE;
}


//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														        						 changeRoomMode
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
BUTTON_EVENT[dvPanelsMain,100]
{
	PUSH:
	{
		q.roomCombined = !q.roomCombined

		IF(q.roomCombined == TRUE)
		{
			//room description
			tpButtonUnicode(dvPanelsMainFrappe, 101, '00530041004C004500200050004F014101040043005A004F004E00450020002D00200047014100D30057004E0059002000500041004E0045004C002000530054004500520055004A010400430059')

			//show sources room mocca
			tpButtonShow(dvPanelsMainFrappe, 102)
			tpButtonUnicode(dvPanelsMainFrappe, 103, '00500052005A0045014101040043005A0045004E00490045002000530041004C0049')
			tpButtonText(dvPanelsMainFrappe, 104, 'ZMIANA TUNERA TELEWIZYJNEGO')
			tpButtonUnicode(dvPanelsMainFrappe, 105, '005A004D00490041004E00410020005300540052004F004E0059002000570059015A0057004900450054004C0041004E004900410020005000520045005A0045004E005400410043004A0049')

			tpPopupShow(dvPanelsMainMocca, 'lockPanel')
		}
		ELSE
		{
			//room description
			tpButtonText(dvPanelsMainFrappe, 101, 'SALA FRAPPE')

			//hide sources room mocca
			tpButtonHide(dvPanelsMainFrappe, 102)
			tpButtonUnicode(dvPanelsMainFrappe, 103, '')
			tpButtonText(dvPanelsMainFrappe, 104, '')
			tpButtonUnicode(dvPanelsMainFrappe, 105, '')

			tpPopupHide(dvPanelsMainMocca, 'lockPanel')

			//room description
			tpButtonText(dvPanelsMainMocca, 101, 'SALA MOCCA')

			//show sources room mocca
			tpButtonHide(dvPanelsMainMocca, 102)
			tpButtonUnicode(dvPanelsMainMocca, 103, '')
			tpButtonText(dvPanelsMainMocca, 104, '')
			tpButtonUnicode(dvPanelsMainMocca, 106, '')
		}
	}
}


//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														        								   pageFlip
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
BUTTON_EVENT[dvPanelMainFrappe,0]
{
	PUSH:
	{
		SWITCH(BUTTON.INPUT.CHANNEL)
		{
			CASE 1:	tpPopupShow(dvPanelsMainFrappe, 'controlPresentation1')
			CASE 2: tpPopupShow(dvPanelsMainFrappe, 'controlTuner1')
			CASE 3: tpPopupShow(dvPanelsMainFrappe, 'controlLight1')

			CASE 103:
			{
				IF(q.roomCombined == TRUE)
					tpPopupShow(dvPanelsMainFrappe, 'controlPresentation2')
			}
			CASE 104:
			{
				IF(q.roomCombined == TRUE)
					tpPopupShow(dvPanelsMainFrappe, 'controlTuner2')
			}
			CASE 105:
			{
				IF(q.roomCombined == TRUE)
				{
					tpPopupShow(dvPanelsMainFrappe, 'controlLight2')
					q.device.light.settings.isProjectionOnWall = FALSE
				}
			}
		}
	}
}

BUTTON_EVENT[dvPanelMainMocca,0]
{
	PUSH:
	{
		SWITCH(BUTTON.INPUT.CHANNEL)
		{
			CASE 1:	tpPopupShow(dvPanelsMainMocca, 'controlPresentation2')
			CASE 2: tpPopupShow(dvPanelsMainMocca, 'controlTuner2')
			CASE 3: tpPopupShow(dvPanelsMainMocca, 'controlLight2')
		}
	}
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														        							 tunerControl
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
BUTTON_EVENT[dvPanelTuner1Frappe, 0]
{
	PUSH:
	{
		SET_PULSE_TIME(1)
		PULSE[dvTunerFrappe, BUTTON.INPUT.CHANNEL]
	}
}

BUTTON_EVENT[dvPanelTuner2Frappe, 0]
BUTTON_EVENT[dvPanelTuner2Mocca, 0]
{
	PUSH:
	{
		SET_PULSE_TIME(1)
		PULSE[dvTunerMocca, BUTTON.INPUT.CHANNEL]
	}
}

BUTTON_EVENT[dvPanelMainFrappe, 105]
{
	PUSH:
	{
		IF(q.roomCombined == TRUE)
			q.device.light.settings.isProjectionOnWall = TRUE
	}
}

BUTTON_EVENT[dvPanelsMain, 106]
{
	PUSH:
	{
		IF(q.roomCombined == TRUE)
			q.device.light.settings.isProjectionOnWall = FALSE
	}
}