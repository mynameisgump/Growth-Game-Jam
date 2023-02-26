extends Node3D
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var uppergums : MeshInstance3D = $Upper/UpperGums
@onready var upperteeth : MeshInstance3D = $Upper/UpperTeeth
@onready var lowergums : MeshInstance3D = $Lower/LowerGums
@onready var lowerteeth : MeshInstance3D = $Lower/LowerTeeth

var burn_mat = preload ("res://assets/materials/Burn_Mat.tres")
var destroyed = false;
var burning = false;
var cur_burn = 0;

func burn_leg():
	if cur_burn<1:
		cur_burn += 0.005;
		uppergums.get_surface_override_material(0).set_shader_parameter("dissolve_amount", cur_burn)
		upperteeth.get_surface_override_material(0).set_shader_parameter("dissolve_amount", cur_burn)
		lowergums.get_surface_override_material(0).set_shader_parameter("dissolve_amount", cur_burn)
		lowerteeth.get_surface_override_material(0).set_shader_parameter("dissolve_amount", cur_burn)
	else:
		burning = false;
		uppergums.visible=false;
		upperteeth.visible=false;
		lowergums.visible = false
		lowerteeth.visible = false;

func disable():
	uppergums.set_surface_override_material(0,burn_mat);
	upperteeth.set_surface_override_material(0,burn_mat);
	lowergums.set_surface_override_material(0,burn_mat);
	lowerteeth.set_surface_override_material(0,burn_mat);
	burning=true;
	destroyed = true;

func _process(delta):
	if burning:
		burn_leg()
