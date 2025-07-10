extends Area2D

var travelled_distance = 0

var player

func _physics_process(delta):
	const SPEED = 200
	const RANGE = 800
	
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	
	travelled_distance += SPEED * delta
	
	if travelled_distance > RANGE:
		if multiplayer.is_server():
			destroy()


func _on_body_entered(body):
	if multiplayer.is_server():
		if body.has_method("take_damage"):
			body.take_damage(player.player_stats["attack"], 1, 1)
	destroy()

@rpc("authority", "call_local")
func destroy():
	queue_free()

func player_attack():
	return true
