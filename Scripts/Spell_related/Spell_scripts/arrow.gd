extends Area2D

var player 

var attack
var travelled_distance = 0
var speed
var direction

func _ready():
	attack *= player.player_stats["attack"]
	speed = randi_range(75,200)
	self.rotation = deg_to_rad(randf_range(-5.0, 5.0))

func _physics_process(delta):
	const RANGE = 300
	
	
	direction = Vector2.DOWN.rotated(rotation)
	position += direction * speed * delta
	
	
	travelled_distance += speed * delta
	
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
