// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information


function __IS_INTERFACE__(func) {
	throw "function: " + func + " is a pure interface function, and must be overridden in a child!"
}


function IShape() constructor {
	
	static show_wireframe = 0;
	static draw = function() {
		__IS_INTERFACE__(_GMFUNCTION_)
	}
	static refresh = function() {
		__IS_INTERFACE__(_GMFUNCTION_)
	}
	static tick = function() {
		__IS_INTERFACE__(_GMFUNCTION_)
	}
	static get_normal = function() {
		__IS_INTERFACE__(_GMFUNCTION_)
	}
	static get_tangent = function() {
		__IS_INTERFACE__(_GMFUNCTION_)
	}
	static get_nearest_point = function(ix, iy) {
		__IS_INTERFACE__(_GMFUNCTION_)
	}
	
	static get_point_at_t = function(t) {
		__IS_INTERFACE__(_GMFUNCTION_)
	}
	
	
	
	static get_AABB = function() {
		var min_coords = {x: 10000000000000, y:10000000000000}
		var max_coords = {x: -10000000000000, y:-10000000000000}
		var p_size = array_length(points)
		var e_size = array_length(extrema)
		
		for(var i = 0; i < p_size; i += p_size -1) {
			var p = points[i]
			min_coords.x = p.x < min_coords.x ? p.x : min_coords.x
			min_coords.y = p.y < min_coords.y ? p.y : min_coords.y
			max_coords.x = p.x > max_coords.x ? p.x : max_coords.x
			max_coords.y = p.y > max_coords.y ? p.y : max_coords.y
		}
		for(var i = 0; i < e_size; i++) {
			var p = extrema[i]
			min_coords.x = p.x < min_coords.x ? p.x : min_coords.x
			min_coords.y = p.y < min_coords.y ? p.y : min_coords.y
			max_coords.x = p.x > max_coords.x ? p.x : max_coords.x
			max_coords.y = p.y > max_coords.y ? p.y : max_coords.y
		}
		
		var mid = new GrooVEC2((min_coords.x + max_coords.x)/2, (min_coords.y + max_coords.y)/2)
		return {x1: min_coords.x, y1: min_coords.y, x2: max_coords.x, y2: max_coords.y, midpoint: mid}
	}
	
	
	static set_texture = function(tex) {
		sprite = tex;
		is_dirty = true
	}

	static set_stroke = function(s) {
		stroke_thickness = s;
		is_dirty = true
	}
	static set_texture_scale = function(u,v) {
		tex_scale_x = u
		tex_scale_y = v
		is_dirty = true
	}
	static point_in_rect = function(x = mouse_x, y = mouse_y) {
		return point_in_rectangle(x, y, AABB.x1, AABB.y1, AABB.x2, AABB.y2)
	}
	
	tex_scale_x = 1;
	tex_scale_y = 1;
	sprite = -1;
	stroke_thickness = 1;
	v_fmt =	DefaultVertexF()
}


gpu_set_tex_filter(true)
gpu_set_texrepeat(true)

function DefaultVertexF() {
	static format = function() {
		vertex_format_begin()
		vertex_format_add_position()
		vertex_format_add_color()
		vertex_format_add_texcoord()
		return vertex_format_end()
	}()

	return format;
}


function Point() constructor {
	selected = false;
	__intern_points = array_create(argument_count)
	
	for(var i = 0; i < argument_count; i++) {
		__intern_points[i] = argument[i]	
	}
	static is_held = function() {
		if !selected {
			selected = true;	
		}
		return selected
	}
	
	static place = function(x, y) {
		self.x = x;
		self.y = y
	}
	
	static translate = function(x, y) {
		self.x += x
		self.y += y
		return self;
	}
	
	static scale = function(f) {
		self.x *= f
		self.y *= f
		return self;
	}
}

function GrooVEC2(_x, _y) : Point(_x, _y) constructor {
	len = 2;
	x = _x
	y = _y
}

function GrooVEC3(_x, _y, _z) : Point(_x , _y, _z) constructor {
	len = 3;
	x = _x
	y = _y
	z = _z
}


function DeCastlejau(points, t) constructor {
	net = [points]
	degree = array_length(points)
	var working_set = array_last(net)
	var n = degree
		
	for (var i = 0; i < n; i++) {
		var to_append = []
	    for (var j = 0; j < (n - i - 1); j++) {
			var p = new GrooVEC2(0,0);
			p.len = working_set[j].len
	        p.x = working_set[j].x * (1 - t) + working_set[j + 1].x * t;
	        p.y = working_set[j].y * (1 - t) + working_set[j + 1].y * t;
			if p.len == 3
				p.z = working_set[j].z * (1 - t) + working_set[j + 1].z * t;
			to_append[j] = p;
	    }
		array_push(net, to_append)
		working_set = to_append
		to_append = []
	}
	
	array_pop(net)

	
	static get_point = function() {
		return array_last(net)[0]	
	}
	
	static get_tangent = function() {
		var len = array_length(net)
		var ps = net[len-2]
		
		var d_x = ps[1].x - ps[0].x
		var d_y = ps[1].y - ps[0].y
		
		var mag = sqrt(d_x*d_x + d_y*d_y)
		
		return {x: d_x/mag, y:d_y/mag}
	}
	
	static get_normal = function(tang = get_tangent()) {
		var n_x = -tang.y * sin(90)
		var n_y = tang.x
		
		return {x: n_x, y: n_y}
	}
	
	static split = function() {
		var pl1 = []
		var pl2 = []
		
		for(var i = 0; i < degree; i++) {
			var n1 = net[i][0]
			var n2 = array_last(net[(degree-1)-i])
			pl1[i] = n1
			pl2[i] = n2
		}
		return {b1: pl1, b2: pl2 }
	}
	
	static draw = function() {
		
		for(var i = 0; i < array_length(net); i++) {
			var arr = net[i]
			var s = array_length(arr)

			for(var j = 1; j < s; j++) {
				var p1 = arr[j-1]
				var p2 = arr[j]
				
				draw_line(p1.x, p1.y, p2.x, p2.y)
			}
		}
	}
}

new IShape()