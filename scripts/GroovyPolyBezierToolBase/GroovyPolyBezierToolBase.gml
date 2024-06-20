// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function DrawTool(owner = undefined) : GroovyTool(owner) constructor {
	static icon = spr_draw_icon
	static shortcut_key = ord("D")
	static threshold = 10;
	static tension = 0.5;
	static thickness = 30;
	static texture = Sprite1
	static points_queue = [];
	
	/**
	 * Function Description
	 * @param {struct.Polycurve} shape Description
	 */
	static action = function(shape) {
		if mouse_check_button(mb_left) && is_instanceof(shape, Polycurve){
			var p = new GrooVEC2(mouse_x, mouse_y)
			if array_length(points_queue) == 0 || distance(p, array_last(points_queue)) >= threshold
				array_push(points_queue,p)
				
			if array_length(points_queue) == 4 {
				
				var p1 = points_queue[0]
				var p2 = points_queue[1]
				var p3 = points_queue[2]
				var p4 = points_queue[3]
				
				points_queue = [p2, p3, p4]
				
				var b1 = p2;
				var b2;
				var b3;
				var b4 = p3;
				
				var b2x = p2.x + (p3.x - p1.x)/(6*tension)
				var b2y = p2.y + (p3.y - p1.y)/(6*tension)
				b2 = new GrooVEC2(b2x, b2y)
				
				var b3x = p3.x - (p4.x - p2.x)/(6*tension)
				var b3y = p3.y - (p4.y - p2.y)/(6*tension)
				b3 = new GrooVEC2(b3x, b3y)
				
				var bez = new CBezier(b1, b2, b3, b4)
				bez.set_stroke(shape.stroke_thickness)
				bez.sprite = shape.sprite
				
				array_push(shape.shapes, bez)
				shape.refresh();
			}
		}
		
		if mouse_check_button_released(mb_left) {
			array_resize(points_queue, 0)	
		}
	}
	
	static draw = function() {
		
	}
}