extends Area2D

class_name SpellPage

signal exp_obtained

var game

func _ready():
	game = get_tree().get_nodes_in_group("Game")[0]
	
func _on_body_entered(body):
	if body.has_method("exp_gain"):
		game.exp_increase()
		exp_obtained.emit()
		if is_multiplayer_authority():
			destroy()


@rpc("authority", "call_local")
func destroy():
	queue_free()
