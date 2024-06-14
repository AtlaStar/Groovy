/// @description Insert description here
// You can write your code in this editor

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

#region decouple_this_junk
poly = make_bezier_star(irandom_range(3,6),x, y, 40,45,80,0,.5,1,)
//poly.set_texture(Sprite1)
poly.set_stroke(24)
poly.set_texture_scale(1/64, 1/64)
poly.set_texture(Sprite1)
//poly.set_color(col)
poly.refresh()

physics_particle_set_radius(6)
physics_particle_set_density(200)
physics_particle_set_damping(1)
fixtures = poly.apply_fixtures(self)
phy_rotation = random(360)

#endregion

//janky hacks mate
parts = []
parts = object_index.parts
master = false
master = !object_index.master



phy_bullet = true;
//GroovyCanvas.add_new_shape(poly)

physics_world_update_speed(1)

//last_phy_speed_x = phy_speed_x
//last_phy_speed_y = phy_speed_y