extends CharacterBody3D

@onready var left_leg : MeshInstance3D = $LeftLegHit/LeftLegMesh
@onready var right_leg : MeshInstance3D = $RightLegHit/RightLegMesh
@onready var body : MeshInstance3D = $TorsoHit/TorsoMesh

@onready var left_hit : CollisionShape3D = $LeftLegHit
@onready var right_hit : CollisionShape3D = $RightLegHit
@onready var body_hit : CollisionShape3D = $TorsoHit

@onready var right_blood_spray : GPUParticles3D = $RightBlood
@onready var left_blood_spray : GPUParticles3D = $LeftBlood
@onready var torso_blood_spray : GPUParticles3D = $TorsoBlood

@onready var leftLegGibs : Node3D = $LeftLegGibs
@onready var rightLegGibs : Node3D = $RightLegGibs

func damage(hit) -> void:
	if hit == left_hit.name:
		left_hit.disabled = true;
		left_leg.visible = false;
		left_blood_spray.emitting = true;
		var gibs = leftLegGibs.get_children()
		for gib in gibs:
			gib.visible = true
		
	if hit == right_hit.name:
		right_hit.disabled = true;
		right_leg.visible = false;
		right_blood_spray.emitting = true;
		var gibs = rightLegGibs.get_children()
		for gib in gibs:
			gib.visible = true
	
	if hit == body_hit.name:
		right_hit.disabled = true;
		right_leg.visible = false;
		left_hit.disabled = true;
		left_leg.visible = false;
		body_hit.disabled = true;
		body.visible = false;
		right_blood_spray.emitting = false;
		left_blood_spray.emitting = false;
		torso_blood_spray.emitting = true;


