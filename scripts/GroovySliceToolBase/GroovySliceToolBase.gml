// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function SliceTool(owner = undefined) : GroovyTool(owner) constructor {
	static icon = spr_slice_icon;
	static shortcut_key = 0xBF // the '/' key
	static f = 24
	static col = c_yellow
	/// @desc Function Description
	/// @param {struct.IShape} shape Description
	static action = function(shape) {
		if is_instanceof(shape, Polycurve) {
			
		} else if shape != noone {

		}
		return GroovyResult.NO_RESULT_TYPE
	}
	
	static draw = function(shape) {
		if !shape
			return shape
		var np = shape.get_nearest_point(mouse_x, mouse_y)
		if np {
			var scale = f/sprite_get_width(icon)
			draw_sprite_ext(icon, 0, np.x, np.y, scale, scale, 0, col, 1)
		}
	}
}
