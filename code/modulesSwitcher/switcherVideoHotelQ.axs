MODULE_NAME='switcherVideoHotelQ' (DEV vdvVideoSwitcher, DEV vdvKramerFrappe, DEV vdvKramerMocca)
(***********************************************************)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 06/01/2017  AT: 18:48:23        *)
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

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

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

DATA_EVENT[vdvVideoSwitcher]
{
	COMMAND:
	{
		IF(FIND_STRING(DATA.TEXT,'INPUT-',1))
		{
			REMOVE_STRING(DATA.TEXT,'INPUT-',1)

			IF(FIND_STRING(DATA.TEXT, 'FRAPPE_TABLE,', 1))
			{
				REMOVE_STRING(DATA.TEXT, 'FRAPPE_TABLE,', 1)
				SELECT
				{
					ACTIVE(DATA.TEXT == 'FRAPPE'):
					{
						SEND_COMMAND vdvKramerFrappe, 'INPUT-HDMI_1,ROOM'
					}
					ACTIVE(DATA.TEXT == 'MOCCA'):
					{
						SEND_COMMAND vdvKramerFrappe, 'INPUT-HDMI_1,REMOTE'
						SEND_COMMAND vdvKramerMocca, 'INPUT-HDMI_1,ROOM'
					}
				}
			}

			ELSE IF(FIND_STRING(DATA.TEXT, 'FRAPPE_TUNER,', 1))
			{
				REMOVE_STRING(DATA.TEXT, 'FRAPPE_TUNER,', 1)
				SELECT
				{
					ACTIVE(DATA.TEXT == 'FRAPPE'):
					{
						SEND_COMMAND vdvKramerFrappe, 'INPUT-HDMI_3,ROOM'
					}
					ACTIVE(DATA.TEXT == 'MOCCA'):
					{
						SEND_COMMAND vdvKramerFrappe, 'INPUT-HDMI_3,REMOTE'
						SEND_COMMAND vdvKramerMocca, 'INPUT-HDMI_1,ROOM'
					}
				}
			}

			ELSE IF(FIND_STRING(DATA.TEXT, 'MOCCA_TABLE,', 1))
			{
				REMOVE_STRING(DATA.TEXT, 'MOCCA_TABLE,', 1)
				SELECT
				{
					ACTIVE(DATA.TEXT == 'FRAPPE'):
					{
						SEND_COMMAND vdvKramerMocca, 'INPUT-HDMI_2,REMOTE'
						SEND_COMMAND vdvKramerFrappe, 'INPUT-HDMI_2,ROOM'
					}
					ACTIVE(DATA.TEXT == 'MOCCA'):
					{
						SEND_COMMAND vdvKramerMocca, 'INPUT-HDMI_2,ROOM'
					}
				}
			}

			ELSE IF(FIND_STRING(DATA.TEXT, 'MOCCA_TUNER,', 1))
			{
				REMOVE_STRING(DATA.TEXT, 'MOCCA_TUNER,', 1)
				SELECT
				{
					ACTIVE(DATA.TEXT == 'FRAPPE'):
					{
						SEND_COMMAND vdvKramerMocca, 'INPUT-HDMI_3,REMOTE'
						SEND_COMMAND vdvKramerFrappe, 'INPUT-HDMI_2,ROOM'
					}
					ACTIVE(DATA.TEXT == 'MOCCA'):
					{
						SEND_COMMAND vdvKramerMocca, 'INPUT-HDMI_3,ROOM'
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
