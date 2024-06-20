// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function ControlDock() constructor {
	static root = self;
	static tools = []
	self.tools = []
	static icon_size = 32;
	self.icon_size = 32
	static padding = 10
	self.padding = 10;
	static current_canvas = new GroovyCanvas();
	self.current_canvas = new GroovyCanvas()
	static selected_shape = noone;
	self.selected_shape = noone;
	
	static draw = function(shape = undefined) {
		selected_tool.draw(shape ?? selected_shape);
	}
	
	//fix so it isn't so...ugly...and by that I mean absolute in its position.
	static draw_gui = function() {
		
		static width = icon_size*5 + padding*5
		static height = display_get_gui_height()
		static xpos = display_get_gui_width() - width;
		static ypos = 0;
		
		draw_rectangle_color(xpos-padding, ypos, xpos+width, ypos + height, c_dkgray, c_dkgray, c_dkgray, c_dkgray, false)
		gpu_set_blendmode_ext(bm_dest_colour, bm_one);
		
		for(var i = 0; i < array_length(tools); i++) {
			var j = (i*icon_size + i*padding) div width
			var xx = (i*icon_size + i*padding) % width
			var yy = j*icon_size
			var icon = tools[i].icon
			var scale = icon_size/sprite_get_width(icon)
			xx += sprite_get_xoffset(icon)*scale
			yy += sprite_get_yoffset(icon)*scale + padding
			draw_sprite_ext(icon,0, xpos + xx, ypos + yy + padding*j, scale, scale, 0, c_white, 1)
		}
		
		gpu_set_blendmode(bm_normal)
		
		if selected_shape
			draw_text(0,0, "a shape is here")
			
		draw_text(0, 64, instanceof(selected_tool))
	}
	
	static add_tool = function(struct) {
		array_push(tools, struct)
	}
	
	static tick = function(shape = undefined) {
		selected_tool = selected_tool ?? new NullTool()

		var result = selected_tool.action(shape ?? selected_shape)
		if !result.has_result  || is_instanceof(selected_tool, NullTool) {
			if mouse_check_button_pressed(mb_left) {
				var shape_under_mouse = current_canvas.hit_test()
				if selected_shape && selected_shape != shape_under_mouse
					selected_shape.set_wireframe_state(false, true)
				selected_shape = shape_under_mouse
			}
			var res = array_filter(tools, function(tool) {
				return keyboard_check_pressed(tool.shortcut_key)
			})

			if array_length(res) {
				//eventually add some priority system for tool shortcuts
				selected_tool = array_first(res)
			}
		} else if result.has_result && result.retick {
			tick(shape)	
		} else {
		}
	}
	static selected_tool = new NullTool()
	self.selected_tool = new NullTool()
}

#region intialize the Root control dock
//we don't care if this first one gets garbage collected, this just ini's the statics
//because the root dock we will access via the statice
new ControlDock();

//these are automagically assigned to the static root so no need to capture the values
new PanTool(ControlDock)
new SliceTool(ControlDock)
new StampTool(ControlDock)
	//subtools
	new StarTool()
#endregion