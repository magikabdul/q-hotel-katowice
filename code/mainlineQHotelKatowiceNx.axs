PROGRAM_NAME='mainlineQHotelKatowiceNx'
(***********************************************************)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 06/01/2017  AT: 19:59:06        *)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(*
    $History: $

		v 1.0.0.0 (2017-04-13)
			fix:

			change:

			new:

*)
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
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

VOLATILE CHAR latestCodeVersion[] = 'v 1.0.0.0'

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

(***********************************************************)
(*                INCLUDE DEFINITIONS GO BELOW             *)
(***********************************************************)

(***********************************************************)
(*                MODULE CODE GOES BELOW                   *)
(***********************************************************)
//----------------------------------------------------------------------------------------------------
// 																																								   rmsAdapterModule
//----------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------
//  																																						    duetDeviceModules
//----------------------------------------------------------------------------------------------------
DEFINE_MODULE 'Eiki_EK305U_Comm_nl1_0_0' mdlProjector01(vdvProjectorFrappe, dvProjectorFrappe)
DEFINE_MODULE 'Eiki_EK305U_Comm_nl1_0_0' mdlProjector02(vdvProjectorMocca, dvProjectorMocca)
//----------------------------------------------------------------------------------------------------
//  																																				 		 netlinxDeviceModules
//----------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------
//																																											switerModules
//----------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------
// 																																												commModules
//----------------------------------------------------------------------------------------------------

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

#INCLUDE 'qHotelPanelMain'
#INCLUDE 'qHotelPanelPresentation'
#INCLUDE 'qHotelPanelAudio'
#INCLUDE 'qHotelPanelTuner'
#INCLUDE 'qHotelPanelLight'
(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

q.roomCombined = FALSE;

q.device.screen.settings.isControlledEthernet = TRUE;
q.device.screen.settings.ip.address = '10.1.66.13';

q.device.light.settings.isControlledEthernet = TRUE;
q.device.light.settings.ip.address = '192.168.100.40';

q.device.aplifier.settings.isControlledEthernet = TRUE;
q.device.aplifier.settings.ip.address = '10.1.66.12';
q.device.aplifier.settings.ip.port = '3804';

IP_CLIENT_OPEN (dvDbx.PORT, q.device.aplifier.settings.ip.address, 3804, IP_TCP);
//----------------------------------------------------------------------------------------------------
// 																																							  netlinxDeviceModules
//----------------------------------------------------------------------------------------------------
DEFINE_MODULE 'switcherVideoHotelQ' mdlSwitcherVideo(vdvVideoSwitcher, vdvKramerFrappe, vdvKramerMocca)
DEFINE_MODULE 'switcherAudioHotelQ' mdlSwitcherAudio(vdvAudioSwitcher, vdvDbx,
																										 dvPanelVolumeFrappe, dvPanelVolumeMocca)

DEFINE_MODULE 'DBX_ZonePro_COMM' mdlDbx(vdvDbx, dvDbx, dbxControlIp)
DEFINE_MODULE 'FutureNow_FNIP_Comm_nl1_0_0' mdlScreen(vdvScreen, dvFuture)
DEFINE_MODULE 'Helvar_P905_Comm_nl1_0_0' mdlLight(vdvLight, dvLight)

DEFINE_MODULE 'Kramer_VP440_Comm_nl1_0_0' mdlKramer01(vdvKramerFrappe, dvKramerFrappe)
DEFINE_MODULE 'Kramer_VP440_Comm_nl1_0_0' mdlKramer02(vdvKramerMocca, dvKramerMocca)
(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														        deviceCommunicationSettings
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
DATA_EVENT[vdvScreen]
{
	ONLINE:
	{
		SEND_COMMAND vdvScreen, "'PROPERTY-IP_Address,', q.device.screen.settings.ip.address"
		SEND_COMMAND vdvScreen, "'REINIT'"
	}
}

DATA_EVENT[vdvLight]
{
	ONLINE:
	{
		SEND_COMMAND vdvLight, "'PROPERTY-IP_Address,', q.device.light.settings.ip.address"
		SEND_COMMAND vdvLight, "'REINIT'"
	}
}