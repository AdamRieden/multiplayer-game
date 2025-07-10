extends CharacterBody2D

class_name Enemy

var player_array
var game

var SPEED = 30
var ChangingSpeed = 30

#MUST CHANGE THE VALUES IN THE PROGRESS BAR INSPECTOR TO ACTUALLY SEE CHANGE IN HEALTH MAX AND HEALTH VALUE
var max_health
var health 

var skill_holder

var damage = 1

var stun = false
var feared = false
var spawning = true

var status_effects : Array = []

var temp_pos 

func _ready():
	$SpellPage.monitorable = false
	$SpellPage.monitoring = false
	$SpellPage.visible = false
	player_array = get_tree().get_nodes_in_group("Player")
	game =  get_tree().get_nodes_in_group("Game")[0]
	play_spawn_animation()
	max_health = 7 + (game.player_level * 2.5)
	health = max_health
	$HealthBar.max_value = max_health 
	$HealthBar.value = max_health
	#var percent = randf()
	#if percent < .25:
		#skill_holder = true

func play_spawn_animation():
	$AnimatedSprite2D.visible = false
	$HealthBar.visible = false
	set_physics_process(false)
	$SpawnAnimation.play("default")
	await $SpawnAnimation.animation_finished
	$SpawnAnimation.visible = false
	$AnimatedSprite2D.visible = true
	$HealthBar.visible = true
	set_physics_process(true)
	spawning = false
	$SpawnAnimation.queue_free()

func _physics_process(delta):
	
	if player_array != null:
		var closest_player
		var closest_distance
		for player in player_array:
			var distance = self.global_position.distance_to(player.global_position)
			if closest_distance == null || closest_player == null:
				closest_distance = distance
				closest_player = player
			elif distance < closest_distance:
				closest_player = player
				closest_distance = distance
		var target_player = closest_player
		temp_pos = self.global_position
		velocity = global_position.direction_to(target_player.global_position) * ChangingSpeed
		#move_and_slide()
		
		if $Killzone.overlaps_body(closest_player) == true:
			closest_player.take_damage(damage, delta)
		# band aid solution to spawning in blocks
		#if temp_pos == self.global_position:
			#if status_effects.is_empty() == true:
				#self.global_position += Vector2(30,30)
	#
	## checking all status effects on enemy
	#for i in range(status_effects.size()):
		#var effect = status_effects[i]
		#effect.duration -= delta
		#
		#if effect.duration < 0:
			#effect.remove(self)
			#status_effects.remove_at(i)
			#reset_effect()
			#break
		#
	$HealthBar.max_value = max_health


	
#
#func drop_stat():
	#var new_stat = preload("res://Scenes/World_drops/stat_exp.tscn").instantiate()
	#new_stat.global_position = global_position - Vector2(7,7)
	#get_parent().call_deferred("add_child", new_stat)
	#
	
@rpc("any_peer")
func take_damage(player_damage, delta, mult):
	if is_multiplayer_authority():
		if spawning == false:
			health -= player_damage * (delta * mult)
			$HealthBar.value = health
			## Fear condition
			#if health <= (max_health/2): 
				#if feared == false:
					#apply_status_effect(Fear.new(2))
					#feared = true
				#
			if health <= 0:
				set_physics_process(false)
				make_exp_visible()
				#if skill_holder == true:
					#drop_stat()
					
func make_exp_visible():
	$Killzone.set_deferred("monitoring", false)
	$Killzone.set_deferred("monitorable", false)
	%CollisionShapeDA.set_deferred("disabled", true)
	$SpellPage.set_deferred("monitoring", true)
	$SpellPage.set_deferred("monitorable", true)
	$AnimatedSprite2D.visible = false
	$HealthBar.visible = false
	$SpellPage.visible = true


#func apply_status_effect(effect):
	## removes same effect happening again, just adds time to the original effect
	#for i in range(status_effects.size()):
		#if status_effects[i].get_class_name() == effect.get_class_name():
			##if dot, then figured out in their own status effect class
			#if effect.get_dot_bool() == false:
				#status_effects[i].duration = effect.duration
			#return
#
	#status_effects.append(effect)
	#effect.apply(self)
#
	#
#func reset_effect():
	#for i in status_effects:
		#i.apply(self)
	#
#func can_be_stunned():
	#return true
	#
#
#func can_be_slowed():
	#return true

func _on_spell_page_exp_obtained():
	if is_multiplayer_authority():
		destroy()
	
@rpc("authority", "call_local")
func destroy():
	queue_free()
