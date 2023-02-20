extends CharacterBody3D

@onready var legs : Node3D = $Legs

@onready var left_leg : MeshInstance3D = $LeftLegMesh
@onready var right_leg : MeshInstance3D = $RightLegMesh
@onready var body : MeshInstance3D = $TorsoMesh

@onready var left_hit : CollisionShape3D = $LeftLegMesh/StaticBody3D/LeftLegHit
@onready var right_hit : CollisionShape3D = $RightLegMesh/StaticBody3D/RightLegHit
@onready var body_hit : CollisionShape3D = $TorsoMesh/StaticBody3D/TorsoHit

@onready var right_blood_spray : GPUParticles3D = $RightBlood
@onready var left_blood_spray : GPUParticles3D = $LeftBlood
@onready var torso_blood_spray : GPUParticles3D = $TorsoBlood

@onready var left_burn : MeshInstance3D = $LeftLegBurnt
@onready var right_burn : MeshInstance3D = $RightLegBurnt
@onready var torso_burn : MeshInstance3D = $TorsoBurnt

@onready var leftLegGibs : Node3D = $LeftLegGibs
@onready var rightLegGibs : Node3D = $RightLegGibs

@onready var nav_agent : NavigationAgent3D = get_node("NavigationAgent3D")

@onready var animation_player : AnimationPlayer = $AnimationPlayer;

@onready var hurt_box : CollisionShape3D = $HurtBox;

@export var movement_speed : float = 4.0

var movement_delta : float
var SPEED = 3.0;
var dead = false;

var right_burning = false;
var cur_right_burn = 0;
var left_burning = false;
var cur_left_burn = 0;
var torso_burning = false;
var cur_torso_burn = 0;

func update_target_location(target):
	nav_agent.target_position = target;
	
func update_rotation(target):
	self.look_at(target)
	
func burn_right_leg():
	if cur_right_burn<1:
		cur_right_burn += 0.01;
		right_burn.get_surface_override_material(0).set_shader_parameter("dissolve_amount", cur_right_burn)
	else:
		right_burning = false;
		right_burn.visible=false;

func burn_left_leg():
	if cur_left_burn<1:
		cur_left_burn += 0.01;
		left_burn.get_surface_override_material(0).set_shader_parameter("dissolve_amount", cur_left_burn)
	else:
		left_burning = false;
		left_burn.visible=false;
		
func burn_torso():
	if cur_torso_burn<1:
		cur_torso_burn += 0.01;
		torso_burn.get_surface_override_material(0).set_shader_parameter("dissolve_amount", cur_torso_burn)
	else:
		torso_burning = false;
		torso_burn.visible=false;

func _physics_process(delta):

	animation_player.play("Running")
	
	if not dead:
		var current_location = global_transform.origin
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * SPEED

		velocity = new_velocity
		move_and_slide()
		
	if right_burning:
		burn_right_leg()
	
	if left_burning:
		burn_left_leg()
		
	if torso_burning:
		burn_torso()
		
func set_gibs(gibs):
	pass
#	for gib in gibs:
#		gib.top_level = true
#		gib.freeze = false;
#		gib.visible = true;


func disable_left():
	left_hit.disabled = true;
	left_leg.visible = false;
	left_blood_spray.emitting = true;
	left_burn.transform = left_leg.transform;
	left_burning = true;
	left_burn.visible = true;
	var gibs = leftLegGibs.get_children()
	set_gibs(gibs)

func disable_right():
	right_hit.disabled = true;
	right_leg.visible = false;
	right_blood_spray.emitting = true;
	right_burn.transform = right_leg.transform;
	right_burning = true;
	right_burn.visible = true;
	var gibs = rightLegGibs.get_children()
	set_gibs(gibs)
	
func damage(hit) -> void:
	if hit == left_hit.name:
		disable_left()
		
	if hit == right_hit.name:
		disable_right()
	
	if hit == body_hit.name:
		right_hit.disabled = true;
		right_leg.visible = false;
		left_hit.disabled = true;
		left_leg.visible = false;
		body_hit.disabled = true;
		body.visible = false;
		
		left_burn.transform = left_leg.transform;
		right_burn.transform = right_leg.transform;
		
		right_blood_spray.emitting = false;
		left_blood_spray.emitting = false;
		torso_blood_spray.emitting = true;
		
		right_burning = true;
		right_burn.visible = true;
		left_burning = true;
		left_burn.visible = true;
		torso_burning = true;
		torso_burn.visible = true;
		hurt_box.disabled = true;
		hurt_box.visible = false;
		
		var left_gibs = leftLegGibs.get_children()
		set_gibs(left_gibs)
		
		var right_gibs = rightLegGibs.get_children()
		set_gibs(right_gibs)
		
		dead = true;
	else:
		print("Test: ",hit)
		legs.get_node("Leg1").disable_leg();





