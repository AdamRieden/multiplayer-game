extends Area2D

var attack
var player

func _ready():
	attack *= (player.player_stats["attack"]/3)
	for i in range(3):
		$AnimationPlayer.play("Shockwave")
		await $AnimationPlayer.animation_finished
	destroy()
	
func _on_body_entered(body):
	if multiplayer.is_server():
		if body.has_method("take_damage"):
			body.take_damage(attack, 1, 1)
		elif self.overlaps_body(player):
			pass
			#player gains some kind of buff


func player_attack():
	return true
	
	
@rpc("authority", "call_local")
func destroy():
	queue_free()
