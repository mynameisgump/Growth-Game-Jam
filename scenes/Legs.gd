extends Node3D

var legs_alive = true;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var legs = self.get_children();
	legs_alive = false
	for leg in legs:
		if leg.destroyed == false:
			legs_alive = true;
			break
