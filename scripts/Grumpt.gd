extends CharacterBody3D

@onready var legs : Node3D = $Legs
@onready var torsos : Node3D = $Torsos

@onready var nav_agent : NavigationAgent3D = get_node("NavigationAgent3D")

@onready var animation_player : AnimationPlayer = $AnimationPlayer;

@onready var hurt_box : CollisionShape3D = $HurtBox;

@export var movement_speed : float = 4.0

var movement_delta : float
var SPEED = 3.0;
var dead = false;
var torso_burning = false;
var cur_torso_burn = 0;

func update_target_location(target):
	nav_agent.target_position = target;
	
func update_rotation(target):
	self.look_at(target)
		
func _physics_process(delta):

	animation_player.play("Running")
	
	if not dead:
		var current_location = global_transform.origin
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * SPEED

		velocity = new_velocity
		move_and_slide()
		
func set_gibs(gibs):
	pass
#	for gib in gibs:
#		gib.top_level = true
#		gib.freeze = false;
#		gib.visible = true;




	
func damage(hit) -> void:
	if "Torso" in hit:
		dead = true;
		torsos.get_node(NodePath(hit)).disable();
	else:
		print("Test: ",hit)
		var test = "Leg1";
		legs.get_node(NodePath(hit)).disable();





