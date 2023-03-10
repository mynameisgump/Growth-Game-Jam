extends Area3D

@onready var legs : Node3D = $Body/Legs
@onready var torsos : Node3D = $Body/Torsos
@onready var teef : Node3D = $Body/Teef;
@onready var nav_agent : NavigationAgent3D = get_node("NavigationAgent3D")
@onready var animation_player : AnimationPlayer = $AnimationPlayer;
@onready var hurt_box : CollisionShape3D = $HurtBox;
@onready var death_sound : AudioStreamPlayer3D = $DeathSound;
@onready var leg_sound : AudioStreamPlayer3D = $LegDisable;
@onready var hit_sound : AudioStreamPlayer3D = $HitSound;
@onready var hum_sound : AudioStreamPlayer3D = $Hum;

@export var SPEED = 8.0;

var movement_delta : float

var dead = false;
var torso_burning = false;
var cur_torso_burn = 0;
var health;
var rollin = false;

func update_target_location(target):
	nav_agent.target_position = target;
	
func update_rotation(target):
	self.look_at(target)

func die():
	hum_sound.stop()
	if not dead:
		death_sound.play()
		hurt_box.disabled = true
		for leg in legs.get_children():
			if leg.destroyed == false:
				leg.disable()
		for torso in torsos.get_children():
			if torso.destroyed == false:
				torso.disable()
		if teef.destroyed == false:
			teef.disable()
		dead = true;
	

func _ready():
	hum_sound.play()
	health = legs.get_children().size()*2+1;
	for leg in legs.get_children():
		var speed = randf_range(0.8,1.2)
		var leg_animations = leg.get_node("AnimationPlayer")
		leg_animations.speed_scale = speed;
		leg_animations.play("RunHard1");
	teef.get_node("TeefAnimation").play("Chattin");

func _physics_process(delta):
	
	if health <= 0:
		self.die();
	
	if legs.legs_alive == false and rollin==false:
		print("No Lags")
		rollin = true;
		animation_player.play("BeginRoll")
		animation_player.queue("Rolling")
	
	if not dead:
		var current_location = global_transform.origin
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * SPEED

		velocity = new_velocity
		move_and_slide()
		
func damage(hit):
	if not rollin:
		animation_player.play("Hit");
	hit_sound.play()
	var limbs = 0;
	var kills = 0;
	if "Torso" in hit:
		health -= 1;
	else:
		limbs += 1
		health -= 2;
		if health > 0:
			leg_sound.play()
		legs.get_node(NodePath(hit)).disable();
	if health <= 0:
		kills += 1
	return [limbs,kills]
