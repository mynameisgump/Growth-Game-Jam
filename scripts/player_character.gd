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
@onready var stepplayer : AudioStreamPlayer = $Footsteps

#@onready var gun1 : Node3D = $Body/Head/Guns/Gun1
#@onready var gun2 : Node3D = $Body/Head/Guns/Gun2

@export var GRAVITY = -80;
@export var MAX_SPEED: float = 10.0;
# Original Default of 18
@export var JUMP_SPEED = 50;
@export var ACCEL = 4.5;
@export var MAX_ACCEL = 150.0;
@export var DEACCEL= 0.86;
@export var MAX_SLOPE_ANGLE = 40;

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

func _physics_process(delta : float) -> void:
	handle_input(delta);
	handle_movement(delta);
	fire();

func is_moving():
	return Input.is_action_pressed("move_left") or \
	Input.is_action_pressed("move_right") or \
	Input.is_action_pressed("move_up") or \
	Input.is_action_pressed("move_down") 


func fire():
	if Input.is_action_pressed("mouse_fire"):
		var timer = gun1.get_node("GunTimer");
		var animations = gun1.get_node("AnimationPlayer");
		if timer.is_stopped() and not animations.is_playing():
			animations.play("Fire");
			gunshot.play();
			if gun_raycast.is_colliding():
				var target = gun_raycast.get_collider();
				print(target)
				if target.is_in_group("Limbs"):
					#var part_hit = target.get_child(gun_raycast.get_collider_shape()).name;
					var part_hit = target.get_node("../../").name
					print("PartHit: ",part_hit)
					target.get_node("../../../../").damage(part_hit)
					#print(target.get_node("../../../../").get_parent().damage(part_hit));

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
	

