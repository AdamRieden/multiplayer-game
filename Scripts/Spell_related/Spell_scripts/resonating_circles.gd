extends Node2D

@export var spawn_location: Marker2D
@export var SpellResource: Resource
var player

var Shockwave =  preload("res://Scenes/Spells/shockwave.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	%BluePivot.rotation_degrees += delta * PI * SpellResource.speed
	%GreenPivot.rotation_degrees -= delta * PI * SpellResource.speed

@rpc("authority", "call_local") 
func shockwave():
	var new_Shockwave = Shockwave.instantiate()
	new_Shockwave.attack = SpellResource.attack
	new_Shockwave.player = player
	new_Shockwave.global_position = spawn_location.global_position
	new_Shockwave.global_rotation = spawn_location.global_rotation
	spawn_location.call_deferred("add_child", new_Shockwave, true)

# Area that registers when the two circles overlap, not needed for other collisions 
func _on_shockwave_creator_green_area_entered(_area):
	if multiplayer.is_server():
		shockwave.rpc()

@rpc("authority", "call_local")
func destroy():
	queue_free()
