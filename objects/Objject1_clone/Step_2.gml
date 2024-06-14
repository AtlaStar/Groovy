/// @description Insert description here
// You can write your code in this editor

if mouse_check_button(mb_left) {
	//physics_particle_delete_region_circle(mouse_x, mouse_y, 16)
}

if array_length(parts) {
	for(var i = 1; i < array_length(parts); i++) {
		if parts[i-1] != parts[i] {
			physics_particle_group_join(parts[i-1], parts[i])
		}
	}
	array_resize(parts, 1)
}