extends Area2D

var player 

var attack
var travelled_distance = 0

func _ready():
	attack *= player.player_stats["attack"]

func _physics_process(delta):
	const SPEED = 150
	const RANGE = 300
	
	
	var direction = Vector2.DOWN.rotated(rotation)
	position += direction * SPEED * delta
	
	
	travelled_distance += SPEED * delta
	
	if travelled_distance > RANGE:
		if multiplayer.is_server():
			destroy()


func _on_body_entered(body):
	if multiplayer.is_server():
		if body.has_method("take_damage"):
			body.take_damage(attack, 1, 1)
	destroy()

func player_attack():
	return true

@rpc("authority", "call_local")
func destroy():
	queue_free()
