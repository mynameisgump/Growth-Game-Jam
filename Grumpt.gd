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

@onready var vision : Area3D = $Vision

@export var movement_speed : float = 4.0
@onready var nav_agent : NavigationAgent3D = get_node("NavigationAgent3D")

var movement_delta : float
var SPEED = 3.0;
var dead = false;


func update_target_location(target):
	nav_agent.target_position = target;

func _physics_process(delta):
	if not dead:
		var current_location = global_transform.origin

		var next_location = nav_agent.get_next_path_position()

		var new_velocity = (next_location - current_location).normalized() * SPEED

		velocity = new_velocity
		move_and_slide()
		
func set_gibs(gibs):
	for gib in gibs:
		gib.top_level = true
		gib.freeze = false;
		gib.visible = true;

func damage(hit) -> void:
	if hit == left_hit.name:
		left_hit.disabled = true;
		left_leg.visible = false;
		left_blood_spray.emitting = true;
		var gibs = leftLegGibs.get_children()
		set_gibs(gibs)
		
	if hit == right_hit.name:
		right_hit.disabled = true;
		right_leg.visible = false;
		right_blood_spray.emitting = true;
		var gibs = rightLegGibs.get_children()
		set_gibs(gibs)
	
	if hit == body_hit.name:
		right_hit.disabled = true;"process_material"
		right_leg.visible = false;
		left_hit.disabled = true;
		left_leg.visible = false;
		body_hit.disabled = true;
		body.visible = false;
		right_blood_spray.emitting = false;
		left_blood_spray.emitting = false;
		torso_blood_spray.emitting = true;
		
		var left_gibs = leftLegGibs.get_children()
		set_gibs(left_gibs)
		
		var right_gibs = rightLegGibs.get_children()
		set_gibs(right_gibs)
		
		dead = true;





