extends Area2D

@export var SpellResource: Resource

var target_enemy
var target

func _ready():
	self.rotation = deg_to_rad(90)
	print("INStatniate")
	print(self.get_path())

func _physics_process(_delta):
	var enemies_in_range = %HitboxArea.get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)
		$AnimationPlayer.play("Sword_Stab")
	var enemies_in_hurtbox = self.get_overlapping_bodies()
	if enemies_in_hurtbox.size() > 0:
		if target != null && target.has_method("take_damage") && %Hurtbox.disabled == false:
			for enemy in enemies_in_hurtbox:
				if enemy != null:
					enemy.take_damage(SpellResource.attack, .1, 1)
					
	#rotates object to be 90 degrees idling
	if enemies_in_range.size() <= 0 && $AnimationPlayer.is_playing() == false:
		self.rotation = deg_to_rad(90)
		self.modulate.a = .5 
	else:
		self.modulate.a = 1
	

func _on_body_entered(body):
	self.global_position = %Marker2D.global_position
	target = body
	
func player_attack():
	return true
