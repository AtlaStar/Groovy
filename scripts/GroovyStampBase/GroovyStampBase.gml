// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function StampTool() : GroovyTool() constructor {
	static icon = spr_stamp_icon
	static shortcut_key = ord("S")
	static subtools = []
	static is_subtool = false
	static root_tool = self;
	

	static action = function(shape) {
		if keyboard_check(shortcut_key) {
			for(var i = 0; i < array_length(subtools); i++) {
				if keyboard_check_pressed(subtools[i].shortcut_key) {
					ControlDock.selected_tool = subtools[i];
					return GroovyResult.RERUN_LAST_TICK_TYPE
				}
			}
			return GroovyResult.NO_RERUN_LAST_TICK_TYPE
		}
		
		return GroovyResult.NO_RESULT_TYPE
	}
	
	static register_subtools = function() {
		for(var i = 0; i < argument_count; i++) {
			if is_instanceof(argument[i], StampTool) && !root_tool {
				array_push(subtools, argument[i])
				array_pop(ControlDock.tools)
			}
		}
	}
	
	register_subtools(self)
}