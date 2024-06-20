// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function StampTool(owner = undefined) : GroovyTool(owner) constructor {
	static icon = spr_stamp_icon
	static shortcut_key = ord("S")
	static is_subtool = false
	static root_tool = self;

	static subdock = new ControlDock();

	static action = function(shape) {
		if keyboard_check(shortcut_key) {
			/*
			for(var i = 0; i < array_length(subtools); i++) {
				if keyboard_check_pressed(subtools[i].shortcut_key) {
					ControlDock.selected_tool = subtools[i];
					return GroovyResult.RERUN_LAST_TICK_TYPE
				}
			}*/
			return GroovyResult.NO_RERUN_LAST_TICK_TYPE
		}
		return GroovyResult.NO_RESULT_TYPE
	}

	var register_subtools = function() {
		if root_tool != self {
			subdock.add_tool(self)
		} else {
			
		}
	}
	
	register_subtools()
}