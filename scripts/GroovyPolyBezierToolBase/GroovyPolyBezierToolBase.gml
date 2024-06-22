// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function DrawTool(owner = undefined) : GroovyTool(owner) constructor {
	static icon = spr_draw_icon
	static shortcut_key = ord("D")
	static smoothstep = 5000
	static tension = 0.5;
	static thickness = 10;
	static threshold = 100;
	static texture = Sprite1
	static points_queue = [];
	
	static mp1 = undefined
	static mp2 = undefined
	
	/**
	 * Function Description
	 * @param {struct.Polycurve} shape Description
	 */
	static action = function(shape) {

		if mouse_check_button(mb_left) && is_instanceof(shape, Polycurve) {
			var mx = (mouse_x)
			var my = (mouse_y)
			
			var p = new GrooVEC2(mx, my)
			var dist = -1;

			if array_length(points_queue)
				dist = distance(p, array_last(points_queue))
				
			if dist == -1 || dist >= threshold {
				array_push(points_queue,p)
			}

			if array_length(points_queue) == 4 {

				var p1 = points_queue[0]
				var p2 = points_queue[1]
				var p3 = points_queue[2]
				var p4 = points_queue[3]

				mp1 = triangulate_midpoint(p1, p2, p3)
				mp2 = triangulate_midpoint(p2, p3, p4)

				/*
				var a12 = point_direction(p1.x, p1.y, p2.x, p2.y)
				var a34 = point_direction(p3.x, p3.y, p4.x, p4.y)
				var mid = point_direction(mp1.x, mp1.y, mp2.x, mp2.y)
				var avg = (a12 + a23 + a34)/3
				*/

				var a23 = point_direction(p2.x, p2.y, p3.x, p3.y)

				var d1 = distance(mp1, p2)
				var d2 = distance(mp2, p2)

				//make a line
				if d1 > smoothstep || d2 > smoothstep {
					var dist = distance(p3, p4)
					//p4.x = p3.x + lengthdir_x(dist, a23)
					//p4.y = p3.y + lengthdir_y(dist, a23)
					//points_queue = [p3, p4]
				}
				
				/** this is code in test. Testing the idea of smoothing by rectifying the line by injecting points that lay on the circles formed by the points
				
				
				var a1 = point_direction(mp1.x, mp1.y, points_queue[0].x, points_queue[0].y)
				var a2 = point_direction(mp1.x, mp1.y, points_queue[1].x, points_queue[1].y)
				var diff = angle_difference(a1,a2)
				var dist = distance(mp1, points_queue[0])
				var arc_len = dist * degtorad(diff)
				var amount = arc_len/10;
			
			

				while(arc_len div 10) {
					arc_len -= 10*sign(arc_len)
					diff -= diff/amount
				
					var _x = mp1.x + lengthdir_x(dist, a1 + diff)
					var _y = mp1.y + lengthdir_y(dist, a1 + diff)
				
					draw_circle_color(_x, _y, 2, c_aqua, c_aqua, false)
				}
				*/
				points_queue = [p2, p3, p4]

				var b1 = new GrooVEC2(p2.x, p2.y)
				var b2;
				var b3;
				var b4 = new GrooVEC2(p3.x, p3.y);

				var b2x = p2.x + (p3.x - p1.x)/(6*tension)
				var b2y = p2.y + (p3.y - p1.y)/(6*tension)
				b2 = new GrooVEC2(b2x, b2y)

				var b3x = p3.x - (p4.x - p2.x)/(6*tension)
				var b3y = p3.y - (p4.y - p2.y)/(6*tension)
				b3 = new GrooVEC2(b3x, b3y)


				var bez = new CBezier(b1, b2, b3, b4)
				bez.set_stroke(thickness)
				//bez.sprite = shape.sprite
				//bez.set_texture_scale(0.05, 0.05)
				array_push(shape.shapes, bez)
				shape.refresh();
			}
		}

		if mouse_check_button_released(mb_left) {
			array_resize(points_queue, 0)	
		}
	}

	static draw = function() {
		if array_length(points_queue) > 2   &&  mp2 {
			draw_circle_color(mp1.x, mp1.y, distance(mp1, points_queue[0]), c_fuchsia, c_fuchsia, true)
			draw_circle_color(mp2.x, mp2.y, distance(mp2, points_queue[1]), c_fuchsia, c_fuchsia, true)
				
			draw_line_color(mp1.x, mp1.y, mp2.x, mp2.y, c_fuchsia, c_fuchsia)
			
			draw_circle_color(mp1.x, mp1.y, 2, c_aqua, c_aqua, false)
			draw_circle_color(mp2.x, mp2.y, 2, c_aqua, c_aqua, false)

		}

		array_foreach(points_queue, function(point, idx) {		
			draw_circle_color(point.x, point.y, 3, c_fuchsia, c_fuchsia, true)
			//draw_text(point.x, point.y, idx)
			//draw_text(mouse_x, mouse_y + string_height(point)*idx, point)
		})
	}
}