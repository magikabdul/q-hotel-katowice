MODULE_NAME='switcherAudioHotelQ' (DEV vdvAudioSwitcher, DEV vdvDbx,
																	 DEV dvPanelVolumeFrappe, DEV dvPanelVolumeMocca)
(***********************************************************)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 06/01/2017  AT: 20:51:30        *)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(*
    $History: $
*)
#INCLUDE 'SNAPI'
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

#DEFINE DEFINE_DEVICE_PARAMETERS
#IF_NOT_DEFINED DEFINE_DEVICE_PARAMETERS
	vdvAudioSwitcher
	
	vdvDbx
	
	dvPanelVolumeFrappe
	dvPanelVolumeMocca
#END_IF

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

VOLATILE CHAR micOn[] = '286'
VOLATILE CHAR micOff[] = '0'

VOLATILE CHAR lineOn[] = '115'
VOLATILE CHAR lineOff[] = '0'

VOLATILE CHAR inputMicA[] = '1'
VOLATILE CHAR inputMicB[] = '2'
VOLATILE CHAR inputFrappe[] = '7'
VOLATILE CHAR inputMocca[] = '8'

VOLATILE CHAR outputFrappe[] = '1'
VOLATILE CHAR outputMocca[] = '2'
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

DATA_EVENT[vdvAudioSwitcher]
{
	COMMAND:
	{
		IF(FIND_STRING(DATA.TEXT,'INPUT-',1))
		{
			REMOVE_STRING(DATA.TEXT,'INPUT-',1)

			IF(FIND_STRING(DATA.TEXT, 'OFF,', 1))
			{
				REMOVE_STRING(DATA.TEXT, 'OFF,', 1)
				SELECT
				{
					ACTIVE(DATA.TEXT == 'FRAPPE'):
					{
						SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputFrappe,':',inputFrappe,':',lineOff"
						SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputFrappe,':',inputMocca,':',lineOff"
					}
					ACTIVE(DATA.TEXT == 'MOCCA'):
					{
						SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputMocca,':',inputMocca,':',lineOff"
						SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputMocca,':',inputFrappe,':',lineOff"
					}
					ACTIVE(DATA.TEXT == 'BOTH'):
					{
						SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputFrappe,':',inputFrappe,':',lineOff"
						SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputFrappe,':',inputMocca,':',lineOff"
						SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputMocca,':',inputMocca,':',lineOff"
						SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputMocca,':',inputFrappe,':',lineOff"
					}
				}
			}

			ELSE IF(FIND_STRING(DATA.TEXT, 'FRAPPE,', 1))
			{
				REMOVE_STRING(DATA.TEXT, 'FRAPPE,', 1)
				SELECT
				{
					ACTIVE(DATA.TEXT == 'FRAPPE'):	SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputFrappe,':',inputFrappe,':',lineOn"
					ACTIVE(DATA.TEXT == 'MOCCA'):		SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputMocca,':',inputFrappe,':',lineOn"
					ACTIVE(DATA.TEXT == 'BOTH'):
					{
						SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputFrappe,':',inputFrappe,':',lineOn"
						SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputMocca,':',inputFrappe,':',lineOn"
					}
				}
			}

			ELSE IF(FIND_STRING(DATA.TEXT, 'MOCCA,', 1))
			{
				REMOVE_STRING(DATA.TEXT, 'MOCCA,', 1)
				SELECT
				{
					ACTIVE(DATA.TEXT == 'FRAPPE'):	SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputFrappe,':',inputMocca,':',lineOn"
					ACTIVE(DATA.TEXT == 'MOCCA'):		SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputMocca,':',inputMocca,':',lineOn"
					ACTIVE(DATA.TEXT == 'BOTH'):
					{
						SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputFrappe,':',inputMocca,':',lineOn"
						SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputMocca,':',inputMocca,':',lineOn"
					}
				}
			}
		}

		ELSE IF(FIND_STRING(DATA.TEXT, 'MIC_A-', 1))
		{
			REMOVE_STRING(DATA.TEXT, 'MIC_A-', 1)

			IF(FIND_STRING(DATA.TEXT, 'ON,', 1))
			{
				REMOVE_STRING(DATA.TEXT, 'ON,', 1)
				SELECT
				{
					ACTIVE(DATA.TEXT == 'FRAPPE'):
					{
						//SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputFrappe,':',inputMicA,':',micOn"
						SEND_LEVEL dvPanelVolumeFrappe, 1, ATOI(micOn)
						ON[vdvAudioSwitcher, 11]
					}
					ACTIVE(DATA.TEXT == 'MOCCA'):
					{
						//SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputMocca,':',inputMicA,':',micOn"
						SEND_LEVEL dvPanelVolumeMocca, 1, ATOI(micOn)
						ON[vdvAudioSwitcher, 12]
					}
					ACTIVE(DATA.TEXT == 'BOTH'):
					{
						//SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputFrappe,':',inputMicA,':',micOn"
						SEND_LEVEL dvPanelVolumeFrappe, 1, ATOI(micOn)
						SEND_LEVEL dvPanelVolumeMocca, 1, ATOI(micOn)
						ON[vdvAudioSwitcher, 11]

						//SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputMocca,':',inputMicA,':',micOn"
						ON[vdvAudioSwitcher, 12]
					}
				}
			}
			ELSE IF(FIND_STRING(DATA.TEXT, 'OFF,', 1))
			{
				REMOVE_STRING(DATA.TEXT, 'OFF,', 1)
				SELECT
				{
					ACTIVE(DATA.TEXT == 'FRAPPE'):
					{
						//SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputFrappe,':',inputMicA,':',micOff"
						SEND_LEVEL dvPanelVolumeFrappe, 1, ATOI(micOff)
						OFF[vdvAudioSwitcher, 11]
					}
					ACTIVE(DATA.TEXT == 'MOCCA'):
					{
						//SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputMocca,':',inputMicA,':',micOff"
						SEND_LEVEL dvPanelVolumeMocca, 1, ATOI(micOff)
						OFF[vdvAudioSwitcher, 12]
					}
					ACTIVE(DATA.TEXT == 'BOTH'):
					{
						//SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputFrappe,':',inputMicA,':',micOff"
						SEND_LEVEL dvPanelVolumeFrappe, 1, ATOI(micOff)
						SEND_LEVEL dvPanelVolumeMocca, 1, ATOI(micOff)
						OFF[vdvAudioSwitcher, 11]

						//SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputMocca,':',inputMicA,':',micOff"
						OFF[vdvAudioSwitcher, 12]
					}
				}
			}
		}

		ELSE IF(FIND_STRING(DATA.TEXT, 'MIC_B-', 1))
		{
			REMOVE_STRING(DATA.TEXT, 'MIC_B-', 1)

			IF(FIND_STRING(DATA.TEXT, 'ON,', 1))
			{
				REMOVE_STRING(DATA.TEXT, 'ON,', 1)
				SELECT
				{
					ACTIVE(DATA.TEXT == 'FRAPPE'):
					{
						//SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputFrappe,':',inputMicB,':',micOn"
						SEND_LEVEL dvPanelVolumeFrappe, 2, ATOI(micOn)
						ON[vdvAudioSwitcher, 21]
					}
					ACTIVE(DATA.TEXT == 'MOCCA'):
					{
						//SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputMocca,':',inputMicB,':',micOn"
						SEND_LEVEL dvPanelVolumeMocca, 2, ATOI(micOn)
						ON[vdvAudioSwitcher, 22]
					}
					ACTIVE(DATA.TEXT == 'BOTH'):
					{
						//SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputFrappe,':',inputMicB,':',micOn"
						SEND_LEVEL dvPanelVolumeFrappe, 2, ATOI(micOn)
						SEND_LEVEL dvPanelVolumeMocca, 2, ATOI(micOn)
						ON[vdvAudioSwitcher, 21]

						//SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputMocca,':',inputMicB,':',micOn"
						ON[vdvAudioSwitcher, 22]
					}
				}
			}
			ELSE IF(FIND_STRING(DATA.TEXT, 'OFF,', 1))
			{
				REMOVE_STRING(DATA.TEXT, 'OFF,', 1)
				SELECT
				{
					ACTIVE(DATA.TEXT == 'FRAPPE'):
					{
						//SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputFrappe,':',inputMicB,':',micOff"
						SEND_LEVEL dvPanelVolumeFrappe, 2, ATOI(micOff)
						OFF[vdvAudioSwitcher, 21]
					}
					ACTIVE(DATA.TEXT == 'MOCCA'):
					{
						//SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputMocca,':',inputMicB,':',micOff"
						SEND_LEVEL dvPanelVolumeMocca, 2, ATOI(micOff)
						OFF[vdvAudioSwitcher, 22]
					}
					ACTIVE(DATA.TEXT == 'BOTH'):
					{
						//SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputFrappe,':',inputMicB,':',micOff"
						SEND_LEVEL dvPanelVolumeFrappe, 2, ATOI(micOff)
						SEND_LEVEL dvPanelVolumeMocca, 2, ATOI(micOff)
						OFF[vdvAudioSwitcher, 21]

						//SEND_COMMAND vdvDbx, "'MIXERLEVEL=1:I:',outputMocca,':',inputMicB,':',micOff"
						OFF[vdvAudioSwitcher, 22]
					}
				}
			}
		}
	}
}
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
