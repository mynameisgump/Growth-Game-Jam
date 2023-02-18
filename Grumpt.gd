extends CharacterBody3D

@onready var left_leg : MeshInstance3D = $Left_Leg
@onready var right_leg : MeshInstance3D = $Right_Leg
@onready var body : MeshInstance3D = $Body

@onready var left_hit : CollisionShape3D = $left_leg_hit
@onready var right_hit : CollisionShape3D = $right_leg_hit
@onready var body_hit : CollisionShape3D = $body_hit

@onready var right_blood_spray : GPUParticles3D = $right_blood_spray
@onready var left_blood_spray : GPUParticles3D = $left_blood_spray

func damage(hit) -> void:
	if hit == "left_leg_hit":
		left_hit.disabled = true;
		left_leg.visible = false;
		left_blood_spray.emitting = true;
		
	if hit == "right_leg_hit":
		right_hit.disabled = true;
		right_leg.visible = false;
		right_blood_spray.emitting = true;
	
	if hit == "body_hit":
		body_hit.disabled = true;
		body.visible = false;
