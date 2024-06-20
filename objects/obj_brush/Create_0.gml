/// @description Insert description here
// You can write your code in this editor

active_brush = new NullTool();
is_active = true;

change_brush = function(brush) {
	active_brush = brush
}

set_active = function(state) {
	is_active = state	
}