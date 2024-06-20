/// @description Insert description here
// You can write your code in this editor

active_brush = new DrawTool(ControlDock);
//ControlDock.selected_tool = active_brush
is_active = true;
poly = new Polycurve()
poly.set_texture(Sprite1)
poly.set_stroke(32)
poly.set_texture_scale(.05, .05)
change_brush = function(brush) {
	active_brush = brush
}

set_active = function(state) {
	is_active = state	
}