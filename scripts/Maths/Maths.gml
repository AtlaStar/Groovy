// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function det2x2(r1, r2){
	//2x2 det is ad - bc
	return r1[0]*r2[1] - r1[1]*r2[0]
}

function det3x3(r1, r2, r3) {
	var d1 = r1[0]*det2x2([r2[1], r3[2]], [r2[2], r3[1]])
	var d2 = r1[1]*det2x2([r2[0], r3[2]],[r2[2], r3[0]])
	var d3 = r1[2]*det2x2(r2, r3) //can use this shortcut here since idx 2 won't be touched
	return 	d1 - d2 + d3
}

function distance(p1, p2) {
	var running_sum = 0;
	for(var i = 0; i < p1.len; i++) {
		var diff = p2.__intern_points[i] - p1.__intern_points[i]
		running_sum += diff*diff
	}
	return sqrt(running_sum)
}