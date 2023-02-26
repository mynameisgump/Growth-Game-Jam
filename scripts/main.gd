extends Node3D

@onready var player = $PlayerCharacter
@onready var spawn_timer = $SpawnTimer
@onready var spawns_node = $Spawns
@onready var spawn_noise : AudioStreamPlayer3D = $SpawnPlayer
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var enemies : Node3D = $Enemies
@onready var wavetimer : Timer = $WaveTimer
var spawning = true;
var spawns_arr
var Enemy = preload ("res://scenes/Grumpt.tscn")
var wave_start = false;
var current_wave = 1;
var enemies_spawned = 0;
var wave_enemies = 5;
var spawn_max = 5;
var spawn_min = 1;

func _ready():
	if wave_start == false:
		wavetimer.start();
		wave_start = true;
		#
		player.get_node("HUD/WaveAnimation").play("Wave_Start");
		player.get_node("HUD/HUDAnimations").play("RESET");
	animation_player.play("Sky")
	spawns_arr = spawns_node.get_children()

func new_wave():
	enemies_spawned = 0;
	current_wave += 1;
	spawn_timer.wait_time = max(1, 6 - current_wave);
	wave_enemies = current_wave * 5;
	player.current_wave = 2;
	player.get_node("HUD/WaveAnimation").play("Wave_Start")
	wavetimer.start()
	wave_start = true;

func _physics_process(delta):
	get_tree().call_group('enemy', "update_target_location", player.global_transform.origin)
	get_tree().call_group('enemy', "update_rotation", player.global_transform.origin)
	
	if enemies_spawned >= wave_enemies and enemies.get_children().size() == 0:
		wave_start = false;
		self.new_wave();
	
	if wavetimer.is_stopped() and wave_start:
		if spawning and spawn_timer.is_stopped() and enemies_spawned < wave_enemies:
				enemies_spawned += 1;
				
				var rand_spawn = spawns_arr[randi() % spawns_arr.size()];
				spawn_timer.start();
				var new_grumpt = Enemy.instantiate();
				var rand_speed = randf_range(7.0, 13.0)
				new_grumpt.SPEED = rand_speed
				enemies.add_child(new_grumpt);
				spawn_noise.position = rand_spawn.position;
				spawn_noise.play();
				new_grumpt.set_position(rand_spawn.position);
