/// @description Insert description here
// You can write your code in this editor
//GroovyCanvas.active_canvas.draw()
//control.draw()

/*

gpu_set_colorwriteenable(1,1,1,1)
gpu_set_blendequation_sepalpha(bm_add, bm_eq_reverse_subtract)
gpu_set_blendmode_ext_sepalpha(bm_one, bm_zero, )
physics_particle_draw(phy_particle_flag_colormixing, id, Sprite14, 0)
gpu_set_blendequation(bm_eq_add)
gpu_set_colorwriteenable(1,1,1,1)
gpu_set_blendmode(bm_normal)

/*
var rot = physics_particle_group_get_angle(fixtures)
//var mat1 = matrix_build(x, y, 0,0,0,-phy_rotation, 1, 1, 1)
var mat2 = matrix_build(0,0,0,0,0,-rot,1,1,1)
var mat1 = matrix_build(x, y, 0, 0,0,-rot,1,1,1)
//matrix_stack_push(matrix_multiply(mat1, mat2))
matrix_set(matrix_world, mat1)

poly.draw()

//gpu_set_colorwriteenable()
matrix_stack_pop()
matrix_set(matrix_world, matrix_stack_top())
gpu_set_colorwriteenable(1,1,1,1)




if array_length(fixtures) {
	var g = fixtures[0];
	draw_circle(physics_particle_group_get_centre_x(g), physics_particle_group_get_centre_y(g), 4, true)
}
*/