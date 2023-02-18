extends CharacterBody3D

@onready var left_leg : MeshInstance3D = $Left_Leg
@onready var right_leg : MeshInstance3D = $Right_Leg
@onready var body : MeshInstance3D = $Body

@onready var left_hit : CollisionShape3D = $left_leg_hit
@onready var right_hit : CollisionShape3D = $right_leg_hit
@onready var body_hit : CollisionShape3D = $body_hit
func _physics_process(delta):
	pass
	
func damage(hit) -> void:
	if hit == "left_leg":
		left_hit.disabled = true;
		left_leg.visible = false;
	if hit == "right_leg":
		right_hit.disabled = true;
		right_leg.visible = false;
	if hit == "body":
		body_hit.disabled = true;
		body.visible = false;
