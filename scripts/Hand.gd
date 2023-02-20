extends Node3D


# Called when the node enextends Spatial

var mouse_mov_x
var mouse_mov_y

@export var sway_amount = 0.06
@export var sway_max_amount = 0.25
@export var sway_smooth_amount = 5

@export var sway_threshold = 0.1

var last_mouse_position
var current_mouse_position


func _input(event):
	pass
#	if event is InputEventMouseMotion:
#
#		mouse_mov_x = -event.relative.x
#		mouse_mov_y = event.relative.y

func _process(delta):
	pass
#	if mouse_mov_x != null and mouse_mov_y!=null:
#
#		var movement_x = mouse_mov_x*sway_amount
#		var movement_y = mouse_mov_y*sway_amount
#
#		movement_x = clamp(movement_x,-sway_max_amount,sway_max_amount)
#		movement_y = clamp(movement_y,-sway_max_amount,sway_max_amount)
#
#		if movement_x == -sway_amount or movement_x == sway_amount:
#			movement_x = 0
#		if movement_y == -sway_amount or movement_y == sway_amount:
#			movement_y = 0
#
#		var finalPosition = Vector3(movement_y,movement_x,0)
#
#		rotation = rotation.lerp(finalPosition,sway_smooth_amount*delta)
	
