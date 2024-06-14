/// @description Insert description here
// You can write your code in this editor

if array_length(parts) > 1 && master {
	for(var i = 1; i < array_length(parts); i++) {
		if parts[i-1] != parts[i] && physics_particle_group_count(parts[i-1]) && physics_particle_group_count(parts[i])
			physics_particle_group_join(parts[i-1], parts[i])
	}
	//show_debug_message(parts)
}
