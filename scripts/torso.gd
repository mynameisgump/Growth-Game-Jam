extends Node3D

@onready var torso_mesh : MeshInstance3D = $TorsoMesh
@onready var hitbox : CollisionShape3D = $TorsoMesh/StaticBody3D/TorsoHit
@onready var blood_spray : GPUParticles3D = $BloodSpray

var burn_mat = preload ("res://assets/materials/Burn_Mat.tres")
var destroyed = false;
var burning = false;
var cur_burn = 0;

func burn_torso():
	if cur_burn<1:
		cur_burn += 0.01;
		torso_mesh.get_surface_override_material(0).set_shader_parameter("dissolve_amount", cur_burn)
	else:
		burning = false;
		torso_mesh.visible=false;
		

func disable():
	print("In disable leg")
	hitbox.disabled = true;
	blood_spray.emitting = true;
	torso_mesh.set_surface_override_material(0,burn_mat);
	burning=true;
	destroyed = true;

func _process(delta):
	if burning:
		burn_torso()
