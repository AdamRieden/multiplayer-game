extends Area2D

@export var spawn_location: Marker2D
@export var spawn_node: Node2D


@onready var enemy_spawner = $DarkAngelSpawner

var waittime = 20

var _dark_angel_scene = preload("res://Scenes/Enemy_related/dark_angel.tscn")

func _ready():
	if spawn_node:
		enemy_spawner.spawn_path = spawn_node.get_path()
	else:
		print("Dark Angel Spawn Not Set")
		
	$Timer.wait_time = waittime
	


func _create_dark_angel():
	var dark_angel_to_spawn = _dark_angel_scene.instantiate()
	
	dark_angel_to_spawn.position = spawn_location.position
	
	spawn_node.add_child(dark_angel_to_spawn, true)



func _on_timer_timeout():
	if is_multiplayer_authority():
		call_deferred("_create_dark_angel")
	

func _on_area_entered(_area):
	$Timer.wait_time = waittime
	$Timer.start()


func _on_area_exited(_area):
	$Timer.stop()
	$Timer.wait_time = waittime
