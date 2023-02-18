extends CharacterBody3D

var direction : Vector3
var target_speed : Vector3
var accel : float
var hvel : Vector3

@onready var head  : Node3D = $Body/Head
@onready var camera : Camera3D = $Body/Head/Camera3D
@onready var animation : AnimationPlayer = $AnimationPlayer
@onready var gun_raycast : RayCast3D = $Body/Head/Camera3D/GunRay

@export var GRAVITY = -80
@export var MAX_SPEED: float = 10.0
# Original Default of 18
@export var JUMP_SPEED = 50
@export var ACCEL = 4.5
@export var MAX_ACCEL = 150.0
@export var DEACCEL= 0.86
@export var MAX_SLOPE_ANGLE = 40

# Speed Parameter
const SPEED = 7.0
# Jump Velocity Parameter
const JUMP_VELOCITY = 4.5
# Amount of directional control
const CONTROL : float = 15.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Leaning Variables
var lean_left
var lean_right
var z_tilt = 0.0
var z_tilt_target = 0.0
var z_tilt_value = 0.01
var LEAN_SPEED = 5


func _physics_process(delta : float) -> void:
	handle_input(delta)
	handle_movement(delta)
	fire()

func fire():
	if Input.is_action_pressed("mouse_fire"):
		if not animation.is_playing():
			print("Pew")
			animation.play("RevolverFire")
			if gun_raycast.is_colliding():
				var target = gun_raycast.get_collider()
				
				if target.is_in_group("enemy"):
					print(target)
					var part_hit = target.get_child(gun_raycast.get_collider_shape()).name
					target.damage(part_hit)
					print(part_hit)
					print("Get Get Get Get Got Got Got Got")

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

	move_and_slide()
	

