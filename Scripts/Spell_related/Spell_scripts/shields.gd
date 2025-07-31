extends Node2D

@export var SpellResource: Resource
var player 
var current_angle

func _ready():
	player = get_parent().get_parent().get_parent()
	%Shield1Animation.play("Shield1")
	%Shield2Animation.play("Shield2")
	%Shield3Animation.play("Shield3")
	%Shield4Animation.play("Shield4")
	
func _physics_process(_delta):
	current_angle = player.current_angle
	self.rotation_degrees = current_angle
	
func player_attack():
	return true


# -------------------SHIELD 4-------------------

var Shield4HP = 4

func _on_shield_4_area_body_entered(body):
	if Shield4HP > 0 && %Hurtbox4.disabled == false:
		if body.can_be_stunned() == true:
			if body.stun == false:
				body.apply_status_effect(Stun.new(3))
				Shield4HP -= 1
				#print("SHIELD 4 ", Shield4HP)
	check_health_4()


func _on_shield_4_area_area_entered(area):
	if Shield4HP > 0 && area.has_method("can_be_blocked"):
		Shield4HP -= .5
		block_projectile(area)
	check_health_4()
	
	
func _on_shield_4_timer_timeout():
	Shield4HP = 4
	%Shield4Sprite.modulate.a = 1
	%Hurtbox4.disabled = false
	
func check_health_4():
	#print("Shield4HP ", Shield4HP)
	if Shield4HP == 0:
		%Shield4Sprite.modulate.a = 0.2
		%Shield4Timer.wait_time = SpellResource.shield4cooldown
		%Shield4Timer.start()
		%Hurtbox4.call_deferred("set_disabled", true)
		
# -------------------SHIELD 3-------------------
var Shield3HP = 3
func _on_shield_3_area_body_entered(body):
	if Shield3HP > 0 && %Hurtbox3.disabled == false:
		if body.can_be_stunned() == true:
			if body.stun == false:
				body.apply_status_effect(Stun.new(3))
				Shield3HP -= 1
				#print("SHIELD 3 ", Shield3HP)
	check_health_3()
		
func _on_shield_3_area_area_entered(area):
	if Shield3HP > 0 && area.has_method("can_be_blocked"):
		Shield3HP -= .5
		block_projectile(area)
	check_health_3()
	

func _on_shield_3_timer_timeout():
	Shield3HP = 3
	%Shield3Sprite.modulate.a = 1
	%Hurtbox3.disabled = false
	
func check_health_3():
	#print("Shield3HP ", Shield3HP)
	if Shield3HP == 0:
		%Shield3Sprite.modulate.a = 0.2
		%Shield3Timer.wait_time = SpellResource.shield3cooldown
		%Shield3Timer.start()
		%Hurtbox3.call_deferred("set_disabled", true)
		
		
# -------------------SHIELD 2-------------------
var Shield2HP = 2
func _on_shield_2_area_body_entered(body):
	if Shield2HP > 0 && %Hurtbox2.disabled == false:
		if body.can_be_stunned() == true:
			if body.stun == false:
				body.apply_status_effect(Stun.new(3))
				Shield2HP -= 1
				#print("SHIELD 2 ", Shield2HP)
	check_health_2()


func _on_shield_2_area_area_entered(area):
	if Shield2HP > 0 && area.has_method("can_be_blocked"):
		Shield2HP -= .5
		block_projectile(area)
	check_health_2()
	
	
func _on_shield_2_timer_timeout():
	Shield2HP = 2
	%Shield2Sprite.modulate.a = 1
	%Hurtbox2.disabled = false
	
func check_health_2():
	#print("Shield2HP ", Shield2HP)
	if Shield2HP == 0:
		%Shield2Sprite.modulate.a = 0.2
		%Shield2Timer.wait_time = SpellResource.shield2cooldown
		%Shield2Timer.start()
		%Hurtbox2.call_deferred("set_disabled", true)
		

# -------------------SHIELD 1-------------------

var Shield1HP = 1

func _on_shield_1_area_body_entered(body):
	if Shield1HP > 0 && %Hurtbox1.disabled == false:
		if body.can_be_stunned() == true:
			if body.stun == false:
				body.apply_status_effect(Stun.new(3))
				Shield1HP -= 1
				#print("SHIELD 1 ", Shield1HP)
	check_health_1()


func _on_shield_1_area_area_entered(area):
	if Shield1HP > 0 && area.has_method("can_be_blocked"):
		Shield1HP -= .5
		block_projectile(area)
	check_health_1()
	
	
func _on_shield_1_timer_timeout():
	Shield1HP = 1
	%Shield1Sprite.modulate.a = 1
	%Hurtbox1.disabled = false
	
func check_health_1():
	#print("Shield1HP ", Shield1HP)
	if Shield1HP == 0:
		%Shield1Sprite.modulate.a = 0.2
		%Shield1Timer.wait_time = SpellResource.shield1cooldown
		%Shield1Timer.start()
		%Hurtbox1.call_deferred("set_disabled", true)
		

# -------------------FOR PROJECTILES-------------------

		
func block_projectile(area):
	area.can_be_blocked()
	var global_transform_before = area.global_transform
	area.call_deferred("reparent", self)
	await get_tree().process_frame  # Ensure reparenting is done
	area.global_transform = global_transform_before  # Restore position
	area.top_level = false
	
	
