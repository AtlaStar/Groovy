// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function make_bezier_square(x, y, size, roundness = 1) {
	var p1, p2, p3, tx, ty, sc, r

	p1 = -1 p2 = 0 p3 = 1
	sc = size/2

	p1 *= sc
	p3 *= -1*(p1+1)

	tx = x
	ty = y
	r = roundness
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
	var c1 = new CBezier(p[0], p[1], p[2], p[3])
	var c2 = new CBezier(p[3], p[4], p[5], p[6])
	var c3 = new CBezier(p[6], p[7], p[8], p[9])
	var c4 = new CBezier(p[9], p[10], p[11], p[0])


	return new Polycurve(c1, c2, c3, c4)
}