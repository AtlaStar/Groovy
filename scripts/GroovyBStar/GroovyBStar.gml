// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function make_bezier_star(points, x, y, r_inner, r_mid, r_outer,v_inner=0, v_mid=.5, v_outer=1, i_rot=0, m_rot=0, o_rot=0) {
	var struct = {
		r_inner,
		r_mid,
		r_outer,
		p_inner: array_create(points*2),
		p_mid: array_create(points*2),
		p_outer: array_create(points*2)
	}
	
	static_set(struct, static_get(IShape))
	
	var _x = 0
	var _y = 0
	
	for(var idx = 0; idx < points; idx++) {
		var ang = 2*pi/points
		var inner = struct.p_inner
		var mid = struct.p_mid
		var outer = struct.p_outer
		var wiggle = ang/2 * v_inner 
		
		inner[idx*2] = new GrooVEC2(cos(idx*ang + i_rot - wiggle),-sin(idx*ang + i_rot - wiggle))
			.scale(r_inner)
			.translate(_x, _y)
		inner[idx*2+1] = new GrooVEC2(cos(idx*ang + i_rot + wiggle),-sin(idx*ang + i_rot + wiggle))
			.scale(r_inner)
			.translate(_x, _y)
			
		wiggle = ang/2 * v_mid
		
		mid[idx*2] = new GrooVEC2(cos(idx*ang + m_rot -wiggle),-sin(idx*ang + m_rot - wiggle))
			.scale(r_mid)
			.translate(_x, _y)
		mid[idx*2+1] = new GrooVEC2(cos(idx*ang + m_rot + wiggle),-sin(idx*ang + m_rot + wiggle))
			.scale(r_mid)
			.translate(_x, _y)
			
		wiggle = ang/2 * v_outer
		
		outer[idx*2] = new GrooVEC2(cos(idx*ang + o_rot - wiggle),-sin(idx*ang + o_rot - wiggle))
			.scale(r_outer)
			.translate(_x, _y)
		outer[idx*2+1] = new GrooVEC2(cos(idx*ang + o_rot + wiggle),-sin(idx*ang + o_rot + wiggle))
			.scale(r_outer)
			.translate(_x, _y)
	}

	var poly = new ClosedPolycurve()
	poly.shapes = [];
	poly.points = points;
	poly.r1 = r_inner
	poly.r2 = r_mid
	poly.r3 = r_outer
	
	poly.v1 = v_inner
	poly.v2 = v_mid
	poly.v3 = v_outer
	
	poly.rot1 = i_rot
	poly.rot2 = m_rot
	poly.rot3 = o_rot
	
	for(var i = 0; i < points*2; i+=2) {

		//standard way, when v_outer and v_mid are not both equal to 1
		var j = i;
		if i+2 >= points*2 {
			j = -2
		}
		
		if r_inner == r_mid && r_mid == r_outer {
			array_push(poly.shapes, new CBezier(struct.p_outer[i], struct.p_outer[i+1], struct.p_outer[(j+2)], struct.p_outer[j+3]))
			if i = points break
		} else if r_mid == r_outer  || r_inner == r_mid {
			array_push(poly.shapes, new CBezier(struct.p_inner[i], struct.p_outer[i], struct.p_outer[i+1], struct.p_inner[i+1]))
			array_push(poly.shapes, new CBezier(struct.p_inner[i+1], struct.p_outer[i+1], struct.p_outer[j+2], struct.p_inner[j+2]))
		} else {
			var b1 = new CBezier(struct.p_mid[i], struct.p_inner[i], struct.p_inner[i+1], struct.p_mid[i+1])
			var b2 = new CBezier(struct.p_mid[i+1], struct.p_outer[i+1], struct.p_outer[j+2], struct.p_mid[j+2])
			array_push(poly.shapes, b1, b2)
		}
	}
	
	return poly
}



function StarTool(owner = undefined) : StampTool(owner) constructor {
	static icon = spr_stamp_icon;
	static shortcut_key = ord("8")
	static action_in_progress = false;
	//default circle radii 
	static dr1 = 90
	static dr2 = 120
	static dr3 = 200
	
	static dpoints = 5;
	static points = dpoints
	
	static r1 = dr1
	static r2 = dr2
	static r3 = dr3
	static r1held = false
	static r2held = false
	static r3held = false;
	
	static dv1 = 0
	static dv2 = .5
	static dv3 = 1
	
	static v1 = dv1
	static v2 = dv2
	static v3 = dv3
	v1held = false
	v2held = false
	v3held = false
	
	
	static rot1 = 0
	static rot2 = 0
	static rot3 = 0
	
	static action = function(shape) {
		if is_instanceof(shape, ClosedPolycurve)	{
			r1 = shape.r1
			r2 = shape.r2
			r3 = shape.r3
			
			v1 = shape.v1
			v2 = shape.v2
			v3 = shape.v3
			
			rot1 = shape.rot1
			rot2 = shape.rot2
			rot3 = shape.rot3
			
			points = shape.points
			
			if mouse_check_button_pressed(mb_left) {
				if on_ring(shape, r3) {
					r3held = true;
				} else if on_ring(shape,r2) {
					r2held = true	
				} else if on_ring(shape, r1) {
					r1held = true;	
				}
			}
			
			var npoints = mouse_wheel_up() - mouse_wheel_down()
			
			points += npoints
			if r1held {
				r1 += distance_from_ring(shape, r1)
			}			
			if r2held {
				r2 += distance_from_ring(shape, r2)
			}			
			
			if r3held {
				r3 += distance_from_ring(shape, r3)
			}			

			if mouse_check_button_released(mb_left) {
				r1held = false
				r2held = false
				r3held = false;
			}
			
			if r1held || r2held || r3held || npoints != 0 {
				var new_shape = make_bezier_star(points, shape.x, shape.y, r1, r2, r3, v1, v2, v3, rot1, rot2, rot3)
				new_shape.set_stroke(shape.stroke_thickness)
				new_shape.set_texture(shape.sprite)
				new_shape.set_texture_scale(shape.tex_scale_x, shape.tex_scale_x)
				new_shape.refresh(shape.VBO);
				shape.AABB = new_shape.AABB
				shape.shapes = new_shape.shapes
				
				shape.points = new_shape.points
				shape.r1 = new_shape.r1
				shape.r2 = new_shape.r2
				shape.r3 = new_shape.r3
				
				shape.v1 = new_shape.v1
				shape.v2 = new_shape.v2
				shape.v3 = new_shape.v3
				
				shape.rot1 = new_shape.rot1
				shape.rot2 = new_shape.rot2
				shape.rot3 = new_shape.rot3
				shape.set_wireframe_state(true,false)
				return GroovyResult.NO_RERUN_LAST_TICK_TYPE
			} else {
				shape.show_wireframe = false;	
			}
			
		} else if shape != noone {
			return GroovyResult.NO_RESULT_TYPE
		} else {
			if mouse_check_button_pressed(mb_left)  && GroovyCanvas.active_canvas.hit_test() == noone {
				var new_shape = make_bezier_star(points, mouse_x, mouse_y, dr1, dr2, dr3, dv1, dv2, dv3, rot1, rot2, rot3)
				//new_shape.sprite = Sprite1;
				new_shape.set_stroke(4)
				new_shape.refresh()
				GroovyCanvas.active_canvas.add_new_shape(new_shape)
				ControlDock.selected_shape = new_shape
			}
			return GroovyResult.NO_RESULT_TYPE
		}
		return GroovyResult.NO_RESULT_TYPE
	}
	static draw = function(shape) {
		if is_instanceof(shape, ClosedPolycurve)	{
			var c1 = on_ring(shape, r1) ? c_yellow : c_silver;
			var c2 = on_ring(shape, r2) ? c_yellow : c_silver;
			var c3 = on_ring(shape, r3) ? c_yellow : c_silver;
			draw_circle_color(shape.x, shape.y, r1, c1, c1, true)
			draw_circle_color(shape.x, shape.y, r2, c2, c2, true)
			draw_circle_color(shape.x, shape.y, r3, c3, c3, true)

			
		} else if shape != noone {
			
		} else {
			
		}
	}
	
	static on_ring = function(shape, ring) {

		var dsqr = distance_from_ring(shape, ring)
		return dsqr < 20 && dsqr > -20
	}
	
	static distance_from_ring = function(shape, ring, ax = mouse_x, ay = mouse_y) {
		var dx = mouse_x - shape.x
		var dy = mouse_y - shape.y
		return sqrt(dx*dx + dy*dy) - ring
	}
}