extends Node3D

@onready var leg_mesh : MeshInstance3D = $LegMesh
@onready var hitbox : CollisionShape3D = $LegMesh/StaticBody3D/LegHit
@onready var blood_spray : GPUParticles3D = $BloodSpray

var burn_mat = preload ("res://assets/materials/Burn_Mat.tres")
var destroyed
var burning = false;
var cur_burn = 0;

func burn_leg():
	if cur_burn<1:
		cur_burn += 0.005;
		leg_mesh.get_surface_override_material(0).set_shader_parameter("dissolve_amount", cur_burn)
	else:
		burning = false;
		leg_mesh.visible=false;
		

func disable():
	hitbox.disabled = true;
	blood_spray.emitting = true;
	leg_mesh.set_surface_override_material(0,burn_mat);
	burning=true;
	destroyed = true;

func _process(delta):
	if burning:
		burn_leg()
