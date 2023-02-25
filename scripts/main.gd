extends Node3D

@onready var player = $PlayerCharacter
@onready var spawn_timer = $SpawnTimer
@onready var spawns_node = $Spawns
@onready var spawn_noise : AudioStreamPlayer3D = $SpawnPlayer
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var enemies : Node3D = $Enemies
var spawning = true;
var spawns_arr
var Enemy = preload ("res://scenes/Grumpt.tscn")

func _ready():
	animation_player.play("Sky")
	spawns_arr = spawns_node.get_children()

func _physics_process(delta):
	get_tree().call_group('enemy', "update_target_location", player.global_transform.origin)
	get_tree().call_group('enemy', "update_rotation", player.global_transform.origin)
	
	if spawning:
		if spawn_timer.is_stopped():
			enemies.queue_free()
			var rand_spawn = spawns_arr[randi() % spawns_arr.size()];
			spawn_timer.start();
			var new_grumpt = Enemy.instantiate();
			add_child(new_grumpt);
			spawn_noise.position = rand_spawn.position;
			spawn_noise.play();
			new_grumpt.set_position(rand_spawn.position);
