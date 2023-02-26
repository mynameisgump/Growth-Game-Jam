extends CharacterBody3D;

var direction : Vector3;
var target_speed : Vector3;
var accel : float;
var hvel : Vector3;

@onready var head  : Node3D = $Body/Head;
@onready var camera : Camera3D = $Body/Head/Camera3D;
@onready var animation : AnimationPlayer = $AnimationPlayer;
@onready var gun_raycast : RayCast3D = $Body/Head/Camera3D/GunRay;
@onready var guns_node : Node3D = $Body/Head/Guns;

@onready var gun1 : Node3D = $Body/Head/Guns/Gun1;
@onready var gunshot : AudioStreamPlayer2D = $Gunshot;
@onready var steptimer : Timer = $StepTimer;
@onready var attacktimer : Timer = $AttackTimer
@onready var stepplayer : AudioStreamPlayer = $Footsteps
@onready var hud : CanvasLayer = $HUD
@onready var hud_health : Label = $HUD/Elements/Health
@onready var hud_limbs : Label = $HUD/Elements/Limbs
@onready var hud_brains : Label = $HUD/Elements/Brains
@onready var hud_wave : Label = $HUD/WaveLabel
@onready var iFrames : Timer = $iFrames
@onready var hitbox : CollisionShape3D = $HitBox;
@onready var hurt_noise : AudioStreamPlayer = $HurtNoise;
@onready var hud_animations : AnimationPlayer = $HUD/HUDAnimations;
@onready var wave_animation : AnimationPlayer = $HUD/WaveAnimation;
@onready var death_animation : AnimationPlayer = $DeathAnimation;
@onready var death_sound : AudioStreamPlayer = $DeathSound;


signal player_death;
@export var GRAVITY = -80;
@export var MAX_SPEED: float = 10.0;
# Original Default of 18
@export var JUMP_SPEED = 50;
@export var ACCEL = 4.5;
@export var MAX_ACCEL = 150.0;
@export var DEACCEL= 0.86;
@export var MAX_SLOPE_ANGLE = 40;
@export var current_wave = 1;

# Speed Parameter
const SPEED = 7.0;
# Jump Velocity Parameter
const JUMP_VELOCITY = 4.5;
# Amount of directional control
const CONTROL : float = 15.0;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity");

# Leaning Variables
var lean_left;
var lean_right;
var z_tilt = 0.0;
var z_tilt_target = 0.0;
var z_tilt_value = 0.01;
var LEAN_SPEED = 5;

var held_gibs = 0;
var health = 100;
var brains = 0;
var limbs = 0;
var alive = true;
var death_scene = false;
var gun_index = 1;

func _physics_process(delta : float) -> void:
	hud_health.text = "Health: "+str(health);
	hud_limbs.text = "Limbs: "+str(limbs);
	hud_brains.text = "Brains: "+str(brains);
	hud_wave.text = "Wave "+str(current_wave);
	
	if alive:
		handle_input(delta);
		handle_movement(delta);
		fire();

	else:
		if death_scene == false:
			death_animation.play("death");
			death_sound.play();
			death_scene = true;

func damage():
	if iFrames.is_stopped():
		iFrames.start()
		health -= 5;
		hurt_noise.play()
		hud_animations.play("Hurt")
		if health <=0:
			alive = false;
			emit_signal("player_death");

func is_moving():
	return Input.is_action_pressed("move_left") or \
	Input.is_action_pressed("move_right") or \
	Input.is_action_pressed("move_up") or \
	Input.is_action_pressed("move_down") 


func fire():
	if Input.is_action_just_pressed("mouse_fire"):
		if attacktimer.is_stopped():
			attacktimer.start();
			var cur_gun = guns_node.get_node("Gun"+str(gun_index));
			var gun_timer = cur_gun.get_node("GunTimer");
			var gun_animations = cur_gun.get_node("AnimationPlayer");
			if gun_timer.is_stopped():
				gun_timer.start()
				gun_animations.play("Fire");
				gunshot.play();
				if gun_index == 2:
					gun_index = 1;
				else:
					gun_index += 1;
				
				if gun_raycast.is_colliding():
					var target = gun_raycast.get_collider();
					if target.is_in_group("Limbs"):
						print("Target:", target.name)
						var part_hit = target.get_node("../../").name
						print("Part Hit:", part_hit)
						var dmg_arr = target.get_node("../../../../../").damage(part_hit)
						limbs += dmg_arr[0]
						brains += dmg_arr[1]
						animation.play("HitMarker")
				
					
func handle_input(delta : float) -> void:
	
	z_tilt_target = 0.0
	
	var cam_xform = camera.get_global_transform()
	
	if Input.is_action_pressed("move_left"):
		lean_left = true
		z_tilt_target = z_tilt_value*5
		
	if Input.is_action_pressed("move_right"):
		lean_right = true
		z_tilt_target = -z_tilt_value*5

func handle_movement(delta : float) -> void:
			
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * CONTROL)

	hvel = velocity
	hvel.y = 0.0
	hvel *= DEACCEL
	
	if hvel.length() < MAX_SPEED * 0.01:
		hvel = Vector3.ZERO
	
	var speed = hvel.dot(direction)

	var accel = clamp(MAX_SPEED - speed, 0.0, MAX_ACCEL * delta)
	hvel += direction * accel
	
	velocity.x = hvel.x
	velocity.z = hvel.z
	
	# Leaning code
	z_tilt += (z_tilt_target-z_tilt)*LEAN_SPEED*delta
	head.rotation.z = z_tilt
	if is_moving():
		if steptimer.is_stopped():
			stepplayer.pitch_scale = randf_range(0.8, 1.2);
			stepplayer.play()
			steptimer.start()


	move_and_slide()
	

