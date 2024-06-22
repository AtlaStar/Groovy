// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

/**
 * Function Description
 * @param {struct.Point} ... variable argument count of points
 */
function Bezier() : IShape() constructor {
	static g_res = 20;
	fixtures = [];
	//fixture = physics_fixture_create();
	color = c_white
	fixture_points = []
	static get_fixture_points = function(lp1, lp2, p, nx_off = 0, ny_off = 0) {

			//we move a point to 0, because we need to ensure the points are somewhat normalized before solving for the center of the circle
			//formed by the 3 points
			var x1 = 0
			var x2 = lp2.x - lp1.x
			var x3 = p.x - lp1.x + nx_off
			//var x3 = AABB.midpoint.x - lp1.x
				
			var y1 = 0
			var y2 = lp2.y - lp1.y
			var y3 = p.y - lp1.y + ny_off
			//var y3 = AABB.midpoint.y - lp1.y
				
			var r1 = 0
			var r2 = x2*x2 + y2*y2
			var r3 = x3*x3 + y3*y3
				
			//simplified math because of having 0 for x1, y1, and r1
			var det11 = det2x2([x2, y2], [x3,y3])
			var det12 = det2x2([r2, y2], [r3, y3])
			var det13 = det2x2([r2, x2], [r3, x3])
				
			if det11 == 0 {
				//well fuck, we are on a line
				var mx1 = min(lp1.x, lp2.x, p.x)
				var mx2 = max(lp1.x, lp2.x, p.x)
				var my1 = min(lp1.y, lp2.y, p.y)
				var my2 = max(lp1.y, lp2.y, p.y)
				return [{x:mx1, y:my1}, {x:mx2, y:my2}]//
			}

			var mx = .5 * det12/det11;
			var my = -.5 * det13/det11;
				

			var np = new GrooVEC2(p.x + nx_off, p.y + ny_off)
			var arr = [{x:x1, y:y1, orig: lp1}, {x: x2, y:y2, orig: lp2}, {x:x3, y:y3, orig: np}]
			array_sort(arr, method({mx, my}, function(e1, e2) {
				return sign(point_direction(mx, my, e1.x, e1.y) - point_direction(mx, my, e2.x, e2.y))
			}))
			
			return arr
	}
	
	static gen_fixtures = function() {

		var func = function(idx) {
			var nx_off = normals[idx].x * stroke_thickness/2
			var ny_off = normals[idx].y * stroke_thickness/2
			
			var po = net_mesh_lut[idx].get_point()
			var p1 = new GrooVEC2(po.x - nx_off, po.y - ny_off)
			var p2 = new GrooVEC2(po.x + nx_off, po.y + ny_off)
			return [p1, p2]
		}
		
				
		var pf = array_first(points)
		var pl = array_last(points)
		
		
		
		array_resize(fixture_points, 0)
		
		var ps = func(0)
		array_push(fixture_points, ps[0], ps[1])
		//var ps = func(g_res/4)
		//array_push(fixture_points, ps[0], ps[1])
		var ps = func(g_res/2)
		array_push(fixture_points, ps[0], ps[1])
		//var ps = func(g_res/4*3)
		//array_push(fixture_points, ps[0], ps[1])
		var ps = func(g_res)
		array_push(fixture_points, ps[0], ps[1])

		array_foreach(fixtures, function(fixture) {
			physics_fixture_delete(fixture)
		})
		
		for(var i = 0; i < array_length(fixture_points) - 2; i++) {
			var fix = physics_fixture_create();
			var arr = get_fixture_points(fixture_points[i], fixture_points[i+1], fixture_points[i+2])

			if array_length(arr) == 3 {
				physics_fixture_set_polygon_shape(fix)
				physics_fixture_add_point(fix, arr[2].orig.x, arr[2].orig.y)
				physics_fixture_add_point(fix, arr[1].orig.x, arr[1].orig.y)
				physics_fixture_add_point(fix, arr[0].orig.x, arr[0].orig.y)
			} else if array_length(arr) == 2 {
				physics_fixture_set_edge_shape(fix, arr[0].x,arr[0].y, arr[1].x, arr[1].y)
			}
			array_push(fixtures, fix)
		}
		return fixtures
	}
	
	static get_particle_fixtures = function(xpos, ypos, flags, group_flags, color, category) {
		var func = function(idx) {
			var nx_off = normals[idx].x * stroke_thickness/2
			var ny_off = normals[idx].y * stroke_thickness/2
			
			var po = net_mesh_lut[idx].get_point()
			var p1 = new GrooVEC2(po.x - nx_off, po.y - ny_off)
			var p2 = new GrooVEC2(po.x + nx_off, po.y + ny_off)
			return [p1, p2]
		}
		
				
		var pf = array_first(points)
		var pl = array_last(points)
		
		
		array_resize(fixture_points, 0)
		
		var ps = func(0)
		array_push(fixture_points, ps[0], ps[1])
		//var ps = func(g_res/4)
		//array_push(fixture_points, ps[0], ps[1])
		var ps = func(g_res/2)
		array_push(fixture_points, ps[0], ps[1])
		//var ps = func(g_res/4*3)
		//array_push(fixture_points, ps[0], ps[1])
		var ps = func(g_res)
		
		array_foreach(fixtures, function(fixture) {
			physics_fixture_delete(fixture)
		})
		
		array_push(fixture_points, ps[0], ps[1])
		for(var i = 0; i < array_length(fixture_points) - 2; i++) {
			var arr = get_fixture_points(fixture_points[i], fixture_points[i+1], fixture_points[i+2])
			
			physics_particle_group_begin(flags, group_flags, xpos, ypos, 0, 0,0,0,color,1, 10, category)
			physics_particle_group_polygon()
			if array_length(arr) == 3 {
				//physics_fixture_set_polygon_shape(fix)
				physics_particle_group_add_point(arr[2].orig.x, arr[2].orig.y)
				physics_particle_group_add_point(arr[1].orig.x, arr[1].orig.y)
				physics_particle_group_add_point(arr[0].orig.x, arr[0].orig.y)
			} else if array_length(arr) == 2 {
				//physics_fixture_set_edge_shape(fix, arr[0].x,arr[0].y, arr[1].x, arr[1].y)
			}
			var g = physics_particle_group_end()
			array_push(fixtures, g)
		}
		return fixtures
	}
	
	static fill_VBO = function(_vbo = VBO) {
		static lp = -1
		var mid = new GrooVEC2(
			0,
			0
		)
		for(var i = 0; i < array_length(net_mesh_lut); i++) {

			var elem = net_mesh_lut[i]
			var p = elem.get_point();

			var nx_off = normals[i].x*stroke_thickness/2
			var ny_off = normals[i].y*stroke_thickness/2

			var np1 = new GrooVEC2(p.x - nx_off, p.y - ny_off)
			var np2 = new GrooVEC2(p.x + nx_off, p.y + ny_off)

			vertex_position(_vbo, p.x - nx_off, p.y - ny_off)
			vertex_color(_vbo, color, 1)

			if sprite > -1 {
				var h_c = sprite_get_height(sprite)*tex_scale_y
				var w_c = sprite_get_width(sprite)*tex_scale_x
			} else {
				var h_c = 1
				var w_c = 1
			}
			var u = (p.x - nx_off)/w_c
			var v = (p.y - ny_off)/h_c
			vertex_texcoord(_vbo, u, v)
			
			vertex_position(_vbo, p.x + nx_off, p.y + ny_off)
			vertex_color(_vbo, color, 1)
			u = (p.x + nx_off)/w_c
			v = (p.y + ny_off)/h_c
			vertex_texcoord(_vbo, u,v)
		}
		return _vbo
	}
	
	static refresh = function(_vbo = VBO < 0 ? vertex_create_buffer() : VBO, create_vbuff = true) {
		if !is_dirty && !create_vbuff
			return fill_VBO()
		else if !is_dirty
			return -1;
		static regen = function(idx) { return new DeCastlejau(points, idx/g_res) }
		static get_norms = function(idx) {
			static last_norm = get_normal(idx/g_res);
			var norm = get_normal(idx/g_res)
			
			if idx > 0 && idx != g_res {
				var t1 = sign(norm.x) != sign(last_norm.x)
				var t2 = sign(norm.y) != sign(last_norm.y)
				last_norm = norm;
				if t1 || t2 {		
					var p = net_mesh_lut[idx-1].get_point()
					var nx_off = norm.x*stroke_thickness/2
					var ny_off = norm.y*stroke_thickness/2
					array_push(extrema, {x: p.x - nx_off, y: p.y - ny_off})
					array_push(extrema, {x: p.x + nx_off, y: p.y + ny_off})
				} 
			} else if idx == 0 || idx == g_res{
				var p = net_mesh_lut[idx].get_point()
					var nx_off = norm.x*stroke_thickness/2
					var ny_off = norm.y*stroke_thickness/2
					array_push(extrema, {x: p.x - nx_off, y: p.y - ny_off})
					array_push(extrema, {x: p.x + nx_off, y: p.y + ny_off})
			}
			return norm;
		}
		
		VBO = _vbo
		extrema = []
		net_mesh_lut = array_create_ext(g_res+1, regen)
		normals = array_create_ext(g_res+1, get_norms)
		AABB = get_AABB();

		if create_vbuff {
			vertex_begin(VBO, v_fmt)
		}
		
		fill_VBO()
		
		if create_vbuff {
			vertex_end(VBO)
		}
		is_dirty = false;
	}
	
	static draw = function (x, y, draw_vbo = true) {
		if VBO < 0
			return -1;
		if draw_vbo {
			vertex_submit(VBO, pr_trianglestrip, sprite > -1 ? sprite_get_texture(sprite, 0) : -1)
		}

		if show_wireframe < 1
			return -1;
		array_foreach(points, function(elem) {
			var col = c_aqua*!elem.selected + c_fuchsia*elem.selected
			draw_circle_color(elem.x, elem.y, 4, col, col, false)
		})
		var p1 = points[0]
		var p2 = points[1]
		var p3 = points[2]
		var p4 = points[3]
		draw_line_color(p1.x, p1.y, p2.x, p2.y, c_aqua, c_aqua)
		draw_line_color(p3.x, p3.y, p4.x, p4.y, c_aqua, c_aqua)
		
		array_foreach(extrema, function(p, i) {
			draw_circle_color(p.x, p.y, 4, c_red, c_red, false)	
		})
		
		var col = array_length(selected) ? c_fuchsia : c_aqua
		
		draw_rectangle_color(AABB.x1, AABB.y1, AABB.x2, AABB.y2,col, col, col, col,true)
	}
	
	static get_net_at_nearest_point = function(ix, iy) {
			var idx1 = 0
			var idx2 = g_res
			

			var pf = net_mesh_lut[idx1].get_point()
			var pl = net_mesh_lut[idx2].get_point()
			var nfx = (ix - pf.x)
			var nfy = (iy - pf.y)
			var nlx = (ix - pl.x)
			var nly = (iy - pl.y)
			
			var d1, d2, p;
			d1 = sqrt(nfx*nfx + nfy*nfy)
			d2 = sqrt(nlx*nlx + nly*nly)
			
			for(var i = 0; i <= g_res; i++) {
				var p = net_mesh_lut[i].get_point()
				var px = (ix - p.x)
				var py = (iy - p.y)
				
				var d = sqrt(px*px + py*py)
				
				if d <= d1 {
					d2 = d1;
					d1 = d;
					idx2 = idx1
					idx1 = i
				} else if d < d2 {
					d2 = d
					idx2 = i
				}
			}
			return new DeCastlejau(points, ((idx2 + idx1)/2)/g_res)
	}
	
	static get_nearest_point = function(ix, iy) {
		return get_net_at_nearest_point(ix, iy).get_point()	
	}
	
	static get_point_at_t = function(t) {
		t = round(t*g_res)
		
		return net_mesh_lut[t].get_point()
	}
	
	static tick = function() {
		var res = show_wireframe;
		show_wireframe = keyboard_check(vk_alt) && keyboard_check_pressed(ord("W")) ? !res : res
		if mouse_check_button_pressed(mb_left) {
			var ctrl = keyboard_check_direct(vk_control)
			
			if !ctrl
				selected = []
			var context = self;
			array_foreach(points, method({ctrl, context}, function(elem) {
				if !ctrl
					elem.selected = false;
				var res = point_in_circle(mouse_x, mouse_y, elem.x, elem.y, 4)
				if res {
					elem.selected = true
					array_insert(context.selected, 0,elem)
					context.selected = array_unique(context.selected)
				}
			}))
		}
		
		if mouse_check_button(mb_left) && array_length(selected) {
			var old_x = selected[0].x
			var old_y = selected[0].y
			selected[0].place(mouse_x, mouse_y)
			for(var i = 1; i < array_length(selected); i++) {
				selected[i].translate(mouse_x - old_x, mouse_y - old_y)	
			}
			is_dirty = true;
		}

		if is_dirty {
			refresh()
			return 1;
		}
		return 0
	}
	
	points = [];
	for(var i = 0; i < argument_count; i++) {
		array_push(self.points, argument[i])	
	}

	VBO = -1;
	selected = [];
	extrema = []
	AABB = get_AABB()
	is_dirty = true;
}

function CBezier(_A,_B,_C,_D) : Bezier(_A,_B,_C,_D) constructor {
	
	static get_normal = function(t) {
		var tan_xy = get_tangent(t);
		var n_x = -tan_xy.y * sin(90)
		var n_y = tan_xy.x
		
		return {x: n_x, y: n_y}
	}
	
	static get_tangent = function(t) {
		
		var ps = net_mesh_lut[t*g_res].get_tangent()
		return ps;
		/*
		var d_x = ps[1].x - ps[0].x
		var d_y = ps[1].y - ps[0].y
		
		var mag = sqrt(d_x*d_x + d_y*d_y)
		
		return {x: d_x/mag, y:d_y/mag}
		*/
	}
}

function QBezier(_A,_B,_C) : Bezier(_A,_B,_C) constructor {

}


function GroovyResult() {
	static NO_RESULT_TYPE = {has_result: false}
	static RERUN_LAST_TICK_TYPE = {has_result: true, retick: true}
	static NO_RERUN_LAST_TICK_TYPE = {has_result: true, retick: false}
	static RETURNS_NEW_SHAPE = function(shape) {
		
		return {has_result: true, retick: false, shape}	
	}
}
GroovyResult()

function GroovyCanvas() constructor {
	shapes = []
	static active_canvas = self;
	static add_new_shape = function(shape) {
		array_push(active_canvas.shapes, shape)
	}
	static change_active_canvas = function(canvas) {
		active_canvas = canvas
	}
	static hit_test = function() {
		var arr = array_filter(shapes, function(shape) {
			return shape.point_in_rect()
		})
		
		if array_length(arr) return arr[0]
		return noone;
	}
	
	static tick = function() {
		array_foreach(shapes, function(shape) {
			shape.tick()	
		})	
	}
	
	static draw = function() {
		array_foreach(shapes, function(shape) {
			shape.draw()
		})	
	}
}


function triangulate_midpoint(p1, p2, p3) {
	//we move a point to 0, because we need to ensure the points are somewhat normalized before solving for the center of the circle
	//formed by the 3 points
	var x1 = 0
	var x2 = p2.x - p1.x
	var x3 = p3.x - p1.x

				
	var y1 = 0
	var y2 = p2.y - p1.y
	var y3 = p3.y - p1.y

				
	var r1 = 0
	var r2 = x2*x2 + y2*y2
	var r3 = x3*x3 + y3*y3
				
	//simplified math because of having 0 for x1, y1, and r1
	var det11 = det2x2([x2, y2], [x3, y3])
	var det12 = det2x2([r2, y2], [r3, y3])
	var det13 = det2x2([r2, x2], [r3, x3])
				
	if det11 == 0 {
		//well fuck, we are on a line
		var mx1 = min(p1.x, p2.x, p3.x)
		var mx2 = max(p1.x, p2.x, p3.x)
		var my1 = min(p1.y, p2.y, p3.y)
		var my2 = max(p1.y, p2.y, p3.y)
		return new GrooVEC2((mx1+mx2)/2, (my1+my2)/2)
	}

	var mx = .5 * det12/det11 + p1.x;
	var my = -.5 * det13/det11 + p1.y;
	
	return new GrooVEC2(mx, my)
}