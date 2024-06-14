/// @description Insert description here
// You can write your code in this editor
if view_cam {
	camera_set_view_angle(view_cam, camera_get_view_angle(view_cam) + (mouse_wheel_up() - mouse_wheel_down())/40)
}

if keyboard_check_pressed(vk_space) {
	view_enabled = !view_enabled
}