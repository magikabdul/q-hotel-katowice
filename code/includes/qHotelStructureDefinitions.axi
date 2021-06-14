PROGRAM_NAME='qHotelStructureDefinitions'
(***********************************************************)
(*  FILE CREATED ON: 04/05/2017  AT: 14:44:08              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 05/30/2017  AT: 21:59:12        *)
(***********************************************************)

(***********************************************************)
(*              STRUCTURE DEFINITIONS GO BELOW             *)
(***********************************************************)
#IF_NOT_DEFINED ___QHOTEL_CONFIGURATION_STRUCTURE___

#DEFINE ___QHOTEL_CONFIGURATION_STRUCTURE___

DEFINE_TYPE

STRUCT __QHOTEL_DEVICE_IP_CONTROL {
	CHAR address[15]
	CHAR port[5]
}

STRUCT __QHOTEL_DEVICE_RS_CONTROL {
	CHAR baud[6]
}



STRUCT __QHOTEL_DEVICES_SCREEN_SETTINGS {
	INTEGER isControlledEthernet
	__QHOTEL_DEVICE_IP_CONTROL ip
}

STRUCT __QHOTEL_DEVICES_SCREEN {
	__QHOTEL_DEVICES_SCREEN_SETTINGS settings
}

STRUCT __QHOTEL_DEVICES_LIGHT_SETTINGS {
	INTEGER isControlledEthernet
	__QHOTEL_DEVICE_IP_CONTROL ip

	INTEGER isProjectionOnWall
}


STRUCT __QHOTEL_DEVICES_LIGHT {
	__QHOTEL_DEVICES_LIGHT_SETTINGS settings
}

STRUCT __QHOTEL_DEVICES_KRAMER_SETTINGS {
	__QHOTEL_DEVICE_RS_CONTROL rs
}

STRUCT __QHOTEL_DEVICES_KRAMER {
	__QHOTEL_DEVICES_KRAMER_SETTINGS settings
}

STRUCT __QHOTEL_DEVICES_APLIFIER_SETTINGS {
	INTEGER isControlledEthernet
	__QHOTEL_DEVICE_IP_CONTROL ip
}

STRUCT __QHOTEL_DEVICES_APLIFIER_STATUS {
	INTEGER isInitialized
	INTEGER isCommunicating
}

STRUCT __QHOTEL_DEVICES_APLIFIER_ZONE {
	INTEGER volume
	INTEGER mute
}

STRUCT __QHOTEL_DEVICES_APLIFIER_MIC {
	INTEGER gain
}

STRUCT __QHOTEL_DEVICES_APLIFIER {
	__QHOTEL_DEVICES_APLIFIER_SETTINGS settings
	__QHOTEL_DEVICES_APLIFIER_STATUS status
	__QHOTEL_DEVICES_APLIFIER_ZONE zone[2]
	__QHOTEL_DEVICES_APLIFIER_MIC microphone[2]
}

STRUCT __QHOTEL_DEVICES_PROJECTOR_SETTINGS {
	__QHOTEL_DEVICE_RS_CONTROL rs
}

STRUCT __QHOTEL_DEVICES_PROJECTOR_STATUS {
	INTEGER isInitialized
	INTEGER isCommunicating
	INTEGER isWorking
	INTEGER isCooling
	INTEGER isWarming
}


STRUCT __QHOTEL_DEVICES_PROJECTOR {
	__QHOTEL_DEVICES_PROJECTOR_SETTINGS settings
	__QHOTEL_DEVICES_PROJECTOR_STATUS status
}

STRUCT __QHOTEL_DEVICES {
	__QHOTEL_DEVICES_PROJECTOR projector[2]
	__QHOTEL_DEVICES_APLIFIER aplifier
	__QHOTEL_DEVICES_KRAMER kramer
	__QHOTEL_DEVICES_SCREEN screen
	__QHOTEL_DEVICES_LIGHT light
}

//-----------------------------------------------------------------------------------mainBranch
STRUCTURE __QHOTEL
{
	INTEGER roomCombined
	__QHOTEL_DEVICES device
}


#END_IF