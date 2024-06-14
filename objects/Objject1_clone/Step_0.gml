/// @description Insert description here
// You can write your code in this editor
//test.tick()
//test2.tick()

var val = mouse_wheel_up() - mouse_wheel_down()

/*
if val != 0 {
	var ctrl = keyboard_check(vk_control)
	if !ctrl {
		var current = poly.stroke_thickness
		if current + val > 0 {
			poly.set_stroke(current + val)
		}
	} else {
		roundness += val/100
		vertex_delete_buffer(poly.VBO)
		var old_poly = poly;
		poly = make_bezier_square(x,y, 256, roundness)
		poly.set_stroke(old_poly.stroke_thickness)
		poly.set_texture(old_poly.sprite)
		poly.set_texture_scale(old_poly.tex_scale_x, old_poly.tex_scale_y)
		poly.show_wireframe = true
		poly.refresh()
	}
}*/

if keyboard_check_pressed(ord("R")) {
	//phy_position_x = xstart
	//phy_position_y = ystart

}
//GroovyCanvas.active_canvas.tick()
//control.tick()

if mouse_check_button(mb_left) {
	if point_in_circle(mouse_x, mouse_y, x, y, 256) {
		var dist = 1000
		var ang = point_direction(mouse_x, mouse_y,x, y)
		//physics_apply_force(x, y,lengthdir_x(dist, ang), lengthdir_y(dist, ang))
	}

	
	var inst = instance_nearest(mouse_x, mouse_y, obj_brush)
	var flags = phy_particle_flag_colormixing | phy_particle_flag_water;
	var groupflags = phy_particle_group_flag_solid
	
	var st = false
	var to_call
	with(obj_brush) {
		if !st then to_call = id
	}
	
	var dist = point_distance(0,0,window_mouse_get_delta_x(), window_mouse_get_delta_y())
	
	if physics_particle_count() == 0 && array_length(parts) {
		physics_particle_group_delete(parts[0])
	}
	
	if id == to_call && (physics_particle_count() == 0 || dist){
		physics_particle_group_begin(flags, groupflags, mouse_x, mouse_y, 0, 0, 0, 0, inst.col, 1, 1, 1);
		physics_particle_group_circle(16);
		array_push(parts, physics_particle_group_end())
	}
}

if mouse_check_button(mb_right) {
	var dist = 5000
	var ang = point_direction(x, y,mouse_x,mouse_y)
	//physics_apply_force(x, y,lengthdir_x(dist, ang), lengthdir_y(dist, ang))
	
	if keyboard_check(vk_control)
		physics_particle_delete_region_circle(mouse_x, mouse_y, 64)
}

var px = physics_particle_group_get_x(fixtures)
var py = physics_particle_group_get_y(fixtures)

x = px
y = py

last_mouse_x = mouse_x
last_mouse_y = mouse_y
obj_brush.parts_drawn = false;