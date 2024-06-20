// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function GroovyTool(owner = undefined) constructor {
	static draw = function() {}
	static action = function() {
		return GroovyResult.NO_RESULT_TYPE
	}
	static icon = Sprite9
	static shortcut_key = 0x00;
	if owner
		static_get(owner).add_tool(self)
}

function NullTool(owner = undefined) : GroovyTool(owner) constructor {}
