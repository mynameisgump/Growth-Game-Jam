extends CharacterBody3D

@onready var legs : Node3D = $Legs
@onready var torsos : Node3D = $Torsos
@onready var nav_agent : NavigationAgent3D = get_node("NavigationAgent3D")
@onready var animation_player : AnimationPlayer = $AnimationPlayer;
@onready var hurt_box : CollisionShape3D = $HurtBox;
@onready var death_sound : AudioStreamPlayer3D = $DeathSound;
@onready var leg_sound : AudioStreamPlayer3D = $LegDisable

@export var movement_speed : float = 4.0

var movement_delta : float
var SPEED = 3.0;
var dead = false;
var torso_burning = false;
var cur_torso_burn = 0;
var health = 5;

func update_target_location(target):
	nav_agent.target_position = target;
	
func update_rotation(target):
	self.look_at(target)

func die():
	if not dead:
		death_sound.play()
		for leg in legs.get_children():
			if leg.destroyed == false:
				leg.disable()
		for torso in torsos.get_children():
			if torso.destroyed == false:
				torso.disable()
		dead = true;
	

func _ready():
	for leg in legs.get_children():
		var leg_animations = leg.get_node("AnimationPlayer")
		leg_animations.play("RunBaby1");

func _physics_process(delta):
	animation_player.play("Running")
	if health <= 0:
		self.die();
	
	if not dead:
		var current_location = global_transform.origin
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * SPEED

		velocity = new_velocity
		move_and_slide()
		
func damage(hit) -> void:
	if "Torso" in hit:
		health -= 1;
		# dead = true;
		# torsos.get_node(NodePath(hit)).disable();
	else:
		health -= 2;
		if health > 0:
			leg_sound.play()
		legs.get_node(NodePath(hit)).disable();
