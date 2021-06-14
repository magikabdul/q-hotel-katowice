PROGRAM_NAME='qHotelVariableDefinitions'
(***********************************************************)
(*  FILE CREATED ON: 04/05/2017  AT: 14:44:08              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 05/30/2017  AT: 22:00:51        *)
(***********************************************************)
#IF_NOT_DEFINED __QHOTEL_VARIABLE_DEFINITIONS___
#DEFINE __QHOTEL_VARIABLE_DEFINITIONS___

#INCLUDE 'qHotelStructureDefinitions.axi'
#INCLUDE 'qHotelDeviceDefinitions.axi'
(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

VOLATILE __QHOTEL q

DEV dvPanelsMainFrappe[] = {dvPanelMainFrappe}
DEV dvPanelsPresentationFrappe[] = {dvPanelPresentationFrappe}

DEV dvPanelsMainMocca[] = {dvPanelMainMocca}
DEV dvPanelsPresentationMocca[] = {dvPanelPresentationMocca}

DEV dvPanelsMain[] = {dvPanelMainFrappe, dvPanelMainMocca}
DEV dvPanelsPresentation[] = {dvPanelPresentationFrappe, dvPanelPresentationMocca}

VOLATILE INTEGER dbxControlIp = FALSE;

VOLATILE INTEGER isPanelOnlineFrappe
VOLATILE INTEGER isPanelOnlineMocca

VOLATILE LONG ltimesPanelFeedback[] = {250}

#END_IF