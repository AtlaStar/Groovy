// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function Polycurve() : IShape() constructor {
	shapes = []
	color = c_white
	for(var i = 0; i < argument_count; i++) {
		array_push(shapes, argument[i])
		argument[i].is_dirty = true;
	}
	
	static draw = function() {
		vertex_submit(VBO, pr_trianglestrip, sprite > -1 ? sprite_get_texture(sprite, 0) : -1)
		array_foreach(shapes, function(shape) {
			shape.draw(0,0,false)
		})
		
		if show_wireframe
			draw_rectangle(AABB.x1, AABB.y1, AABB.x2, AABB.y2, true)
	}
	
	static refresh = function(_vbo = VBO < 0 ? vertex_create_buffer() : VBO) {
		VBO = _vbo;

		vertex_begin(VBO, v_fmt)
		array_foreach(shapes, function(shape) {
			shape.refresh(VBO, false)
		})
		vertex_end(VBO)
		
		show_debug_message(vertex_get_number(VBO))
		AABB = get_AABB()
		is_dirty = false;
	}
	
	static get_nearest_point = function(ix, iy) {
		var res = array_filter(shapes, method({ix, iy}, function(shape) {
			var aabb = shape.AABB
			return point_in_rectangle(ix, iy, aabb.x1, aabb.y1, aabb.x2, aabb.y2)	
		}))
		
		array_map_ext(res, method({ix, iy},function(shape) {
			return shape.get_nearest_point(ix, iy)	
		}))
		
		array_sort(res, method({ix, iy},function(e1, e2) {
			var ex1 = (e1.x - ix)
			var ey1 = (e1.y - iy)
			var ex2 = (e2.x - ix)
			var ey2 = (e2.y - iy)
			
			var d1 = ex1*ex1 + ey1*ey1
			var d2 = ex2*ex2 + ey2*ey2
			return sign(d1 - d2)
		}))
		
		return array_length(res) ? res[0] : undefined
	}
	
	static tick = function() {
		
		array_foreach(shapes, function(shape) {
			is_dirty += shape.tick()
		})
		
		
		if keyboard_check(vk_subtract) && mouse_check_button_pressed(mb_left){
			
			var new_shapes = [];
			var dirty = false;
			for(var i = 0; i < array_length(shapes); i++) {
				var shape = shapes[i]
				if !is_instanceof(shape, Bezier) {
					array_push(new_shapes, shape)
					continue
				}
				
				if !point_in_rectangle(mouse_x, mouse_y, shape.AABB.x1, shape.AABB.y1, shape.AABB.x2, shape.AABB.y2) {
					array_push(new_shapes, shape)
					continue
				}
				
				var g_res = shape.g_res
				var net_mesh_lut = shape.net_mesh_lut
				var points = shape.points
				var idx1 = 0
				var idx2 = g_res

				var pf = net_mesh_lut[idx1].get_point()
				var pl = net_mesh_lut[idx2].get_point()
				var nfx = (mouse_x - pf.x)
				var nfy = (mouse_y - pf.y)
				var nlx = (mouse_x - pl.x)
				var nly = (mouse_y - pl.y)
			
				var d1, d2, p;
				d1 = sqrt(nfx*nfx + nfy*nfy)
				d2 = sqrt(nlx*nlx + nly*nly)
			
				for(var j = 0; j <= g_res; j++) {
					var p = net_mesh_lut[j].get_point()
					var px = (mouse_x - p.x)
					var py = (mouse_y - p.y)
				
					var d = sqrt(px*px + py*py)
				
					if d <= d1 {
						d2 = d1;
						d1 = d;
						idx2 = idx1
						idx1 = j
					} else if d < d2 {
						d2 = d
						idx2 = j
					}
				}
				
				var castle = new DeCastlejau(points, ((idx2 + idx1)/2)/g_res)
				
				var ps = castle.split();
				var b1 = ps.b1
				var b2 = ps.b2
				
				b1 = new CBezier(b1[0], b1[1], b1[2], b1[3])
				b1.set_texture(sprite)
				b1.set_stroke(stroke_thickness)
				b1.set_texture_scale(tex_scale_x, tex_scale_y)
				b1.show_wireframe = shape.show_wireframe
				
				b2 = new CBezier(b2[0], b2[1], b2[2], b2[3])
				b2.set_texture(sprite)
				b2.set_stroke(stroke_thickness)
				b2.set_texture_scale(tex_scale_x, tex_scale_y)
				b2.show_wireframe = shape.show_wireframe
				
				dirty = true;
				array_push(new_shapes, b1, b2)
			}
			if dirty {
				is_dirty = true;
				shapes = new_shapes
				refresh();
			}
		}

		if is_dirty {
			refresh();
			return 1
		} else
			return 0
	}
	static get_normal = function() {
		
	}
	
	static get_AABB = function() {
		if !array_length(shapes)
			return {x1:0, y1:0, x2:0, y2:0}
		var s = shapes[0].AABB
		var min_coords = {x: s.x1, y: s.y1}
		var max_coords = {x: s.x2, y: s.y2}
		
		for(var i = 1; i < array_length(shapes); i++) {
			var p = shapes[i].AABB
			min_coords.x = p.x1 < min_coords.x ? p.x1 : min_coords.x
			min_coords.y = p.y1 < min_coords.y ? p.y1 : min_coords.y
			max_coords.x = p.x2 > max_coords.x ? p.x2 : max_coords.x
			max_coords.y = p.y2 > max_coords.y ? p.y2 : max_coords.y
		}
		return {x1: min_coords.x, y1: min_coords.y, x2: max_coords.x, y2: max_coords.y}
	}
	
	static set_texture = function(tex) {
		sprite = tex;
		array_foreach(shapes, function(shape) {
			shape.set_texture(sprite)	
		})
		return self
	}
	
	static set_stroke = function(s) {
		stroke_thickness = s;
		array_foreach(shapes, function(shape) {
			shape.set_stroke(stroke_thickness)	
		})
		is_dirty = true;
		return self
	}
	static set_texture_scale = function(u,v) {
		tex_scale_x = u
		tex_scale_y = v
		
		array_foreach(shapes, function(shape) {
			shape.set_texture_scale(tex_scale_x, tex_scale_y)	
		})
		is_dirty = true;
		return self
	}
	
	static copy = function(pcurve) {
		if VBO > -1
			vertex_delete_buffer(VBO)
		VBO = pcurve.VBO
		AABB = pcurve.AABB
		is_dirty = pcurve.is_dirty
		shapes = pcurve.shapes
		stroke_thickness = pcurve.stroke_thickness
		sprite = pcurve.sprite
		tex_scale_x = pcurve.tex_scale_x
		tex_scale_y = pcurve.tex_scale_y
		color = pcurve.color
	}
	
	static set_wireframe_state = function(state, only_children = false) {
		if !only_children
			show_wireframe = state
		array_foreach(shapes, method({state}, function(shape) {
			shape.show_wireframe = state
		}))
	}
	
	static apply_fixtures = function(inst) {
		var s = array_length(shapes)
		
		var bound_fixtures = []
		for(var i = 0; i < s; i++) {
			var fixtures = shapes[i].gen_fixtures()
			for(var j = 0; j < array_length(fixtures); j++) {
				physics_fixture_set_density(fixtures[j], 20)
				physics_fixture_set_collision_group(fixtures[j], 1)
				physics_fixture_set_restitution(fixtures[j], .1)
				physics_fixture_set_friction(fixtures[j], .2)
				physics_fixture_set_angular_damping(fixtures[j], .6)
				array_push(bound_fixtures, physics_fixture_bind(fixtures[j], inst))
			}
		}
		return bound_fixtures;
	}
	
	static get_particles = function(xpos, ypos, flags, group_flags, color, category) {
		var s = array_length(shapes)
		
		var bound_fixtures = []
		for(var i = 0; i < s; i++) {
			var fixtures = shapes[i].get_particle_fixtures(xpos, ypos, flags, group_flags, color, category)
			for(var j = array_length(fixtures) - 1; j > 0; j--) {
				physics_particle_group_join(fixtures[j-1], fixtures[j])
			}
			array_push(bound_fixtures, fixtures[0])
		}
		
		for(var i = array_length(bound_fixtures)-1; i > 0; i--) {
			physics_particle_group_join(bound_fixtures[i-1], bound_fixtures[i])
		}
		return bound_fixtures[0];
	}
	
	static set_color = function(col) {
		color = col
		array_foreach(shapes, function(shape) {
			shape.color = color;	
		})
		is_dirty = true;
		return self
	}
	
	AABB = get_AABB()
	is_dirty = true;
	VBO = -1;
	refresh();
}

function ClosedPolycurve() : Polycurve() constructor {
	points = 0;
	static refresh = function(_vbo = VBO < 0 ? vertex_create_buffer() : VBO) {
		VBO = _vbo;

		vertex_begin(VBO, v_fmt)
		array_foreach(shapes, function(shape) {
			shape.refresh(VBO, false)
			//shape.show_wireframe = true
			show_wireframe = false;
		})

		if !array_length(shapes)
			return -1;
		var p = shapes[0].get_point_at_t(0)
		var nx_off = shapes[0].normals[0].x * stroke_thickness/2
		var ny_off = shapes[0].normals[0].y * stroke_thickness/2
		
		
		vertex_position(VBO, p.x - nx_off, p.y - ny_off)
		vertex_color(VBO, color, 1)
		
		if sprite > -1 {
			var h_c = sprite_get_height(sprite)*tex_scale_y
			var w_c = sprite_get_width(sprite)*tex_scale_x
		} else {
			var h_c = 1
			var w_c = 1
		}

		var u = (p.x - nx_off)/w_c
		var v = (p.y - ny_off)/h_c
		vertex_texcoord(VBO, u, v)

		vertex_position(VBO, p.x + nx_off, p.y + ny_off)
		vertex_color(VBO, color, 1)
		u = (p.x + nx_off)/w_c
		v = (p.y + ny_off)/h_c
		vertex_texcoord(VBO, u,v)

		vertex_end(VBO)
		AABB = get_AABB()
		is_dirty = false;
	}
}