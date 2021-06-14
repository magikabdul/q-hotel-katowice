PROGRAM_NAME='qHotelPanelLight'
(***********************************************************)
(*  FILE CREATED ON: 05/10/2017  AT: 16:51:14              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 05/29/2017  AT: 11:08:27        *)
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
(*                  THE EVENTS GO BELOW                    *)
(***********************************************************)
DEFINE_EVENT



//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														    						 		frappeLightsAll
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
BUTTON_EVENT[dvPanelLightFrappe, 11]
{
	PUSH:
	{
		IF(q.roomCombined == TRUE)
			SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:13,G:6,L:100,F:300#'"
		ELSE
			SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:13,G:2,L:100,F:300#'"
	}
}

BUTTON_EVENT[dvPanelLightFrappe, 12]
{
	PUSH:
	{
		IF(q.roomCombined == TRUE)
			SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:13,G:6,L:0,F:300#'"
		ELSE
			SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:13,G:2,L:0,F:300#'"
	}
}

BUTTON_EVENT[dvPanelLightFrappe, 13]
{
	PUSH:
	{
		IF(q.roomCombined == TRUE)
			SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:-1,G:6,F:10#'"
		ELSE
			SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:-1,G:2,F:10#'"
	}
	HOLD[2, REPEAT]:
	{
		IF(q.roomCombined == TRUE)
			SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:-1,G:6,F:10#'"
		ELSE
			SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:-1,G:2,F:10#'"
	}
}

BUTTON_EVENT[dvPanelLightFrappe, 14]
{
	PUSH:
	{
		IF(q.roomCombined == TRUE)
			SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:1,G:6,F:10#'"
		ELSE
			SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:1,G:2,F:10#'"
	}

	HOLD[2, REPEAT]:
	{
		IF(q.roomCombined == TRUE)
			SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:1,G:6,F:10#'"
		ELSE
			SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:1,G:2,F:10#'"
	}
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														    						 	 frappeLightsRear
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
BUTTON_EVENT[dvPanelLightFrappe, 21]
{
	PUSH:
	{
		IF(q.roomCombined == TRUE)
		{
			IF(q.device.light.settings.isProjectionOnWall == TRUE)
				SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:13,G:4,L:100,F:300#'"
			ELSE
				SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:13,G:5,L:100,F:300#'"
		}
		ELSE
			SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:13,G:21,L:100,F:300#'"
	}
}

BUTTON_EVENT[dvPanelLightFrappe, 22]
{
	PUSH:
	{
		IF(q.roomCombined == TRUE)
		{
			IF(q.device.light.settings.isProjectionOnWall == TRUE)
				SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:13,G:4,L:0,F:300#'"
			ELSE
				SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:13,G:5,L:0,F:300#'"
		}
		ELSE
			SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:13,G:21,L:0,F:300#'"
	}
}

BUTTON_EVENT[dvPanelLightFrappe, 23]
{
	PUSH:
	{
		IF(q.roomCombined == TRUE)
		{
			IF(q.device.light.settings.isProjectionOnWall == TRUE)
				SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:-1,G:4,F:10#'"
			ELSE
				SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:-1,G:5,F:10#'"
		}
		ELSE
			SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:-1,G:21,F:10#'"
	}
	HOLD[2, REPEAT]:
	{
		IF(q.roomCombined == TRUE)
		{
			IF(q.device.light.settings.isProjectionOnWall == TRUE)
				SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:-1,G:4,F:10#'"
			ELSE
				SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:-1,G:5,F:10#'"
		}
		ELSE
			SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:-1,G:21,F:10#'"
	}
}

BUTTON_EVENT[dvPanelLightFrappe, 24]
{
	PUSH:
	{
		IF(q.roomCombined == TRUE)
		{
			IF(q.device.light.settings.isProjectionOnWall == TRUE)
				SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:1,G:4,F:10#'"
			ELSE
				SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:1,G:5,F:10#'"
		}
		ELSE
			SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:1,G:21,F:10#'"
	}

	HOLD[2, REPEAT]:
	{
		IF(q.roomCombined == TRUE)
		{
			IF(q.device.light.settings.isProjectionOnWall == TRUE)
				SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:1,G:4,F:10#'"
			ELSE
				SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:1,G:5,F:10#'"
		}
		ELSE
			SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:1,G:21,F:10#'"
	}
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														    						 	frappeLightsFront
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
BUTTON_EVENT[dvPanelLightFrappe, 31]
{
	PUSH:
	{
		IF(q.roomCombined == TRUE)
		{
			IF(q.device.light.settings.isProjectionOnWall == TRUE)
				SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:13,G:11,L:100,F:300#'"
			ELSE
				SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:13,G:22,L:100,F:300#'"
		}
		ELSE
			SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:13,G:22,L:100,F:300#'"
	}
}

BUTTON_EVENT[dvPanelLightFrappe, 32]
{
	PUSH:
	{
		IF(q.roomCombined == TRUE)
		{
			IF(q.device.light.settings.isProjectionOnWall == TRUE)
				SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:13,G:11,L:0,F:300#'"
			ELSE
				SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:13,G:22,L:0,F:300#'"
		}
		ELSE
			SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:13,G:22,L:0,F:300#'"
	}
}

BUTTON_EVENT[dvPanelLightFrappe, 33]
{
	PUSH:
	{
		IF(q.roomCombined == TRUE)
		{
			IF(q.device.light.settings.isProjectionOnWall == TRUE)
				SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:-1,G:11,F:10#'"
			ELSE
				SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:-1,G:22,F:10#'"
		}
		ELSE
			SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:-1,G:22,F:10#'"
	}
	HOLD[2, REPEAT]:
	{
		IF(q.roomCombined == TRUE)
		{
			IF(q.device.light.settings.isProjectionOnWall == TRUE)
				SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:-1,G:11,F:10#'"
			ELSE
				SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:-1,G:22,F:10#'"
		}
		ELSE
			SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:-1,G:22,F:10#'"
	}
}

BUTTON_EVENT[dvPanelLightFrappe, 34]
{
	PUSH:
	{
		IF(q.roomCombined == TRUE)
		{
			IF(q.device.light.settings.isProjectionOnWall == TRUE)
				SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:1,G:11,F:10#'"
			ELSE
				SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:1,G:22,F:10#'"
		}
		ELSE
			SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:1,G:22,F:10#'"
	}

	HOLD[2, REPEAT]:
	{
		IF(q.roomCombined == TRUE)
		{
			IF(q.device.light.settings.isProjectionOnWall == TRUE)
				SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:1,G:11,F:10#'"
			ELSE
				SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:1,G:22,F:10#'"
		}
		ELSE
			SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:1,G:22,F:10#'"
	}
}


//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														    						 		 moccaLightsAll
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
BUTTON_EVENT[dvPanelLightMocca, 11]
{
	PUSH:
	{
		SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:13,G:1,L:100,F:300#'"
	}
}

BUTTON_EVENT[dvPanelLightMocca, 12]
{
	PUSH:
	{
		SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:13,G:1,L:0,F:300#'"
	}
}

BUTTON_EVENT[dvPanelLightMocca, 13]
{
	PUSH:
	{
		SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:-1,G:1,F:10#'"
	}
	HOLD[2, REPEAT]:
	{
		SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:-1,G:1,F:10#'"
	}
}

BUTTON_EVENT[dvPanelLightMocca, 14]
{
	PUSH:
	{
		SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:1,G:1,F:10#'"
	}

	HOLD[2, REPEAT]:
	{
		SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:1,G:1,F:10#'"
	}
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														    						 	  moccaLightsRear
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
BUTTON_EVENT[dvPanelLightMocca, 21]
{
	PUSH:
	{
		SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:13,G:12,L:100,F:300#'"
	}
}

BUTTON_EVENT[dvPanelLightMocca, 22]
{
	PUSH:
	{
		SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:13,G:12,L:0,F:300#'"
	}
}

BUTTON_EVENT[dvPanelLightMocca, 23]
{
	PUSH:
	{
		SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:-1,G:12,F:10#'"
	}
	HOLD[2, REPEAT]:
	{
		SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:-1,G:12,F:10#'"
	}
}

BUTTON_EVENT[dvPanelLightMocca, 24]
{
	PUSH:
	{
		SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:1,G:12,F:10#'"
	}

	HOLD[2, REPEAT]:
	{
		SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:1,G:12,F:10#'"
	}
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														    						 	 moccaLightsFront
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
BUTTON_EVENT[dvPanelLightMocca, 31]
{
	PUSH:
	{
		SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:13,G:11,L:100,F:300#'"
	}
}

BUTTON_EVENT[dvPanelLightMocca, 32]
{
	PUSH:
	{
		SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:13,G:11,L:0,F:300#'"
	}
}

BUTTON_EVENT[dvPanelLightMocca, 33]
{
	PUSH:
	{
		SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:-1,G:11,F:10#'"
	}
	HOLD[2, REPEAT]:
	{
		SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:-1,G:11,F:10#'"
	}
}

BUTTON_EVENT[dvPanelLightMocca, 34]
{
	PUSH:
	{
		SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:1,G:11,F:10#'"
	}

	HOLD[2, REPEAT]:
	{
		SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:17,P:1,G:11,F:10#'"
	}
}


//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 																																																														    						 	 storageLightsAll
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
BUTTON_EVENT[dvPanelLightFrappe, 41]
BUTTON_EVENT[dvPanelLightMocca, 41]
{
	PUSH:
	{
		SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:13,G:3,L:100,F:300#'"
	}
}

BUTTON_EVENT[dvPanelLightFrappe, 42]
BUTTON_EVENT[dvPanelLightMocca, 42]
{
	PUSH:
	{
		SEND_COMMAND vdvLight, "'PASSTHRU->V:1,C:13,G:3,L:0,F:300#'"
	}
}