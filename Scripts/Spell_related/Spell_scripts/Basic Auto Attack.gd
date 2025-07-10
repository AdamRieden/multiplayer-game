extends Area2D

@export var spawn_location: Marker2D
@export var spawn_node: Node2D

var enemies_in_range

var player

var shooter_id

var feather_scene = preload("res://Scenes/Spells/feather.tscn")

func _ready():
	player = get_parent()

func _physics_process(_delta):
	enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var closest_enemy
		var closest_distance
		for enemies in enemies_in_range:
			var distance = self.global_position.distance_to(enemies.global_position)
			if closest_distance == null || closest_enemy == null:
				closest_distance = distance
				closest_enemy = enemies
			elif distance < closest_distance:
				closest_enemy = enemies
				closest_distance = distance
		var target_enemy = closest_enemy
		look_at(target_enemy.global_position)


@rpc("authority", "call_local") 
func shoot():
	var new_feather = feather_scene.instantiate()
	#new_feather.set_multiplayer_authority(player.player_id) # Server owns it
	new_feather.player = player
	new_feather.global_position = spawn_location.global_position
	new_feather.global_rotation = spawn_location.global_rotation
	spawn_node.add_child(new_feather, true)

func _on_timer_timeout():
	if multiplayer.is_server():
		if enemies_in_range.size() > 0:
			shoot.rpc() 
