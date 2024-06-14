/// @description Insert description here
// You can write your code in this editor

/*
var p1, p2, p3, tx, ty, sc, r

p1 = -1 p2 = 0 p3 = 1
sc = 64

p1 *= sc
p2 *= sc
p3 *= sc

tx = 300
ty = 200
r = 1.2
var p = [
	new GrooVEC2(p1+tx,p2+ty),
	
	new GrooVEC2(p1+tx,p1*r+ty),
	new GrooVEC2(p1*r+tx,p1+ty),
	
	new GrooVEC2(p2+tx,p1+ty),
	
	new GrooVEC2(p3*r+tx,p1+ty),
	new GrooVEC2(p3+tx,p1*r+ty),
	
	new GrooVEC2(p3+tx,p2+ty),
	
	new GrooVEC2(p3+tx,p3*r+ty),
	new GrooVEC2(p3*r+tx,p3+ty),
	
	new GrooVEC2(p2+tx,p3+ty),
	
	new GrooVEC2(p1*r+tx,p3+ty),
	new GrooVEC2(p1+tx,p3*r+ty),
]
test = new CBezier(p[0], p[1], p[2], p[3])
test2 = new CBezier(p[3], p[4], p[5], p[6])
test3 = new CBezier(p[6], p[7], p[8], p[9])
test4 = new CBezier(p[9], p[10], p[11], p[0])
*/
control = new ControlDock();
new StampTool()
new StarTool()
new PanTool()
new PanTool()
new PanTool()
new PanTool()
new PanTool()
new PanTool()
new PanTool()
new PanTool()
new PanTool()
new PanTool()
randomize()
roundness = 1;
poly = make_bezier_star(irandom_range(3,6),x, y, 20,25,32,0,.5,1,)
//poly.set_texture(Sprite1)
poly.set_stroke(24)
poly.set_texture_scale(1/64, 1/64)
poly.set_texture(Sprite1)
//poly.set_color(col)
poly.refresh()

physics_particle_set_radius(6)
physics_particle_set_density(10000)
physics_particle_set_damping(1)

var flags = phy_particle_flag_colormixing //| phy_particle_flag_wall;
var groupflags = phy_particle_group_flag_solid | phy_particle_group_flag_rigid

fixtures = poly.get_particles(x, y, flags, groupflags, col, id)
//phy_rotation = random(360)

//phy_bullet = true;
//GroovyCanvas.add_new_shape(poly)

physics_world_update_speed(1)

last_mouse_x = mouse_x
last_mouse_y = mouse_y
var p = obj_brush.id[$ "parts"]
parts = p ?? []
p_flag = choose(phy_particle_flag_powder | phy_particle_flag_water)

parts_drawn = false;

//last_phy_speed_x = phy_speed_x
//last_phy_speed_y = phy_speed_y