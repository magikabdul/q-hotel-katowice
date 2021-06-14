﻿PROGRAM_NAME='qHotelDeviceDefinitions'
(***********************************************************)
(*  FILE CREATED ON: 06/24/2016  AT: 16:48:20              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 05/12/2017  AT: 16:11:54        *)
(***********************************************************)

#IF_NOT_DEFINED __QHOTEL_DEVICE_DEFINITIONS__
#DEFINE __QHOTEL_DEVICE_DEFINITIONS__

DEFINE_DEVICE
//------------------------------------- = ----------------------------------------------------panels

dvPanelMainFrappe												= 10001: 1:0
dvPanelPresentationFrappe								= 10001: 2:0
dvPanelVolumeFrappe                     = 10001: 3:0
dvPanelTuner1Frappe											= 10001: 4:0
dvPanelTuner2Frappe											= 10001: 5:0
dvPanelLightFrappe											= 10001: 6:0

dvPanelMainMocca												= 10002: 1:0
dvPanelPresentationMocca								= 10002: 2:0
dvPanelVolumeMocca                      = 10002: 3:0
dvPanelTuner2Mocca                      = 10002: 5:0
dvPanelLightMocca												= 10002: 6:0
//------------------------------------- = ----------------------------------------------------master
dvMaster        												=     0: 1:0
//------------------------------------- = ----------------------------------------------------ipDevices
dvFuture																=     0: 4:0
dvDbx																		=     0: 5:0
dvLight																	=     0: 6:0
//------------------------------------- = ----------------------------------------------------serialDevices(5001) and ICSLan(400x)
dvProjectorFrappe												=  5001: 1:0
dvProjectorMocca												=  5001: 2:0
dvKramerFrappe													=  5001: 3:0
dvKramerMocca														=  5001: 4:0
//------------------------------------- = ----------------------------------------------------irDevices
dvTunerFrappe														=  5001:11:0
dvTunerMocca														=  5001:12:0
//------------------------------------- = ----------------------------------------------------relayDevices

//------------------------------------- = ----------------------------------------------------ioDevices

//------------------------------------- = ----------------------------------------------------avDevices

//------------------------------------- = ----------------------------------------------------dxlink Tx(800x) and Rx(700x)	use port 2 to aviod confilicts in RMS

//------------------------------------- = ----------------------------------------------------virtualSwitchers(3300x)
vdvVideoSwitcher												= 33001: 1:0
vdvAudioSwitcher												= 33002: 1:0

vdvKramerFrappe													= 33006: 1:0
vdvKramerMocca													= 33007: 1:0
//------------------------------------- = ----------------------------------------------------virtualAmplifiers(3301x)
vdvDbx																	= 33011: 1:0
//------------------------------------- = ----------------------------------------------------virtualLift/Screen(3303x)
vdvScreen																= 33031: 1:0
vdvScreenFrappe													= 33031: 1:0
vdvScreenMocca													= 33031: 2:0
//------------------------------------- = ----------------------------------------------------virtualLight(3305x)
vdvLight																= 33051: 1:0
//------------------------------------- = ----------------------------------------------------virtualJalousie(3307x)

//------------------------------------- = ----------------------------------------------------virtualClimate(3309x)

//------------------------------------- = ----------------------------------------------------virtualNetlinxDisplays(3310x)
vdvProjectorFrappe											= 33101: 1:0
vdvProjectorMocca												= 33102: 1:0
//------------------------------------- = ----------------------------------------------------virtualNetlinxAvDevices(3320x - Rx, 3330x - Tx)

//------------------------------------- = ----------------------------------------------------virtualDuetDevices


#END_IF