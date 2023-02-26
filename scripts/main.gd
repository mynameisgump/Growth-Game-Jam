extends Node3D

@onready var player = $PlayerCharacter
@onready var spawn_timer = $SpawnTimer
@onready var spawns_node = $Spawns
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var enemies : Node3D = $Enemies
@onready var wavetimer : Timer = $WaveTimer
var spawning = true;
# var spawns_arr
var Enemy = preload ("res://scenes/Grumpt.tscn");
var Spawn = preload ("res://scenes/Spawn.tscn");
var wave_start = false;
var current_wave = 1;
var enemies_spawned = 0;
var wave_enemies = 1;
var spawn_max = 5;
var spawn_min = 1;
var total_spawn_locs = 4;
var rand_spawn_quads = [[1,1],[-1,-1],[-1,1],[1,-1]];
var spa_cur_quad = 0 

func _ready():
	randomize()
	if wave_start == false:
		wavetimer.start();
		wave_start = true;
		player.get_node("HUD/WaveAnimation").play("Wave_Start");
		player.get_node("HUD/HUDAnimations").play("RESET");
	animation_player.play("Sky")
	for spawn in range(total_spawn_locs):
		var rand_x_quad = rand_spawn_quads[spa_cur_quad][0];
		var rand_z_quad = rand_spawn_quads[spa_cur_quad][1];
		
		var x = randf_range(0,60)*rand_x_quad;
		var z = randf_range(0,60)*rand_z_quad;
		
		spa_cur_quad += 1;
		if spa_cur_quad >= 4:
			spa_cur_quad = 0; 
		
		var new_spawn: Marker3D = Spawn.instantiate();
		new_spawn.name = "Spawn"+str(spawn);
		new_spawn.set_position(Vector3(x,0,z))
		spawns_node.add_child(new_spawn)
	

func new_wave():
	total_spawn_locs += 2;
	for spawn in spawns_node.get_children():
		spawn.queue_free()
	for spawn in range(total_spawn_locs):
		var rand_x_quad = rand_spawn_quads[spa_cur_quad][0];
		var rand_z_quad = rand_spawn_quads[spa_cur_quad][1];
		
		var x = randf_range(0,60)*rand_x_quad;
		var z = randf_range(0,60)*rand_z_quad;
		
		spa_cur_quad += 1;
		if spa_cur_quad >= 4:
			spa_cur_quad = 0; 
		
		var new_spawn: Marker3D = Spawn.instantiate();
		new_spawn.name = "Spawn"+str(spawn);
		new_spawn.set_position(Vector3(x,0,z))
		spawns_node.add_child(new_spawn)
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
				
				var rand_spawn = spawns_node.get_children()[randi() % spawns_node.get_children().size()];
				spawn_timer.start();
				var new_grumpt = Enemy.instantiate();
				var rand_speed = randf_range(7.0, 13.0)
				new_grumpt.SPEED = rand_speed
				enemies.add_child(new_grumpt);
				rand_spawn.get_node("SpawnPlayer").position = rand_spawn.position;
				rand_spawn.get_node("SpawnPlayer").play();
				new_grumpt.set_position(rand_spawn.position);
