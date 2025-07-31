extends Node2D

@export var SpellResource: Resource
@export var spawn_location: PathFollow2D

@onready var game = get_node("/root/Game")


var isactive = false
var player 
func _ready():
	player = get_parent().get_parent().get_parent()
	$Sprite2D.visible = false
	self.set_process(false)
	
func _process(_delta):
	if multiplayer.is_server():
		spawn_arrow.rpc()


func _on_horn_timer_timeout():
	if isactive == false:
		$Sprite2D.visible = true
		%AnimationPlayer.play("Blow_horn")
		await %AnimationPlayer.animation_finished
		%AnimationPlayer.play("Blow_horn")
		self.set_process(true)
		$HornTimer.wait_time = SpellResource.duration
		$HornTimer.start()
		isactive = true

	else:
		$Sprite2D.visible = false
		self.set_process(false)
		$HornTimer.wait_time = SpellResource.cooldown
		$HornTimer.start()
		isactive = false

	
	

@rpc("authority", "call_local") 
func spawn_arrow():
	var new_arrow = preload("res://Scenes/Spells/arrow.tscn").instantiate()
	new_arrow.attack = SpellResource.attack
	new_arrow.player = player
	spawn_location.progress_ratio = randf()
	new_arrow.global_position = spawn_location.global_position
	spawn_location.call_deferred("add_child", new_arrow, true)
	


