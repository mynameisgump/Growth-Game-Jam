extends StaticBody3D


@onready var propel : Node3D = $Body/Propel
@onready var torsos : Node3D = $Body/Torsos
@onready var nav_agent : NavigationAgent3D = get_node("NavigationAgent3D")
@onready var animation_player : AnimationPlayer = $AnimationPlayer;
@onready var hurt_box : CollisionShape3D = $HurtBox;
#@onready var death_sound : AudioStreamPlayer3D = $DeathSound;
#@onready var leg_sound : AudioStreamPlayer3D = $LegDisable;
#@onready var hit_sound : AudioStreamPlayer3D = $HitSound;

@export var movement_speed : float = 4.0

var movement_delta : float
var SPEED = 3.0;
var dead = false;
var torso_burning = false;
var cur_torso_burn = 0;
var health;
var rollin = false;

func update_target_location(target):
	nav_agent.target_position = target;
	
func update_rotation(target):
	self.look_at(target)
