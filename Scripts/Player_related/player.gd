extends CharacterBody2D

class_name PlayerCharacter
#signal health_depleted
#signal player_level_up

@export var SPEED = 55

#MUST CHANGE THE VALUES IN THE PROGRESS BAR INSPECTOR TO ACTUALLY SEE CHANGE IN HEALTH MAX AND HEALTH VALUE
var max_exp = 1#4
var exp_value = 1
var player_level

var max_stat = 1#4
var stat_value = 1

var player_stats = {"attack":2, "defense": 4, "health": 50.0, "max_health": 50.0}
var health_regen = .2 / player_stats["max_health"]

var input_direction


func _enter_tree():
	set_multiplayer_authority(name.to_int())
	
	
func _ready():
	#$Camera2D.zoom = Vector2(3.75, 3.75)
	#%HealthBar.max_value = player_stats["max_health"]
	#%HealthBar.value = player_stats["health"]
	#%LevelUpBar.max_value = max_exp
	#%StatLevelUpBar.max_value = max_stat
	#%StatLevelUpBar.value = 0
	player_level = 1
	
	# get the input direction and handle the movement/deceleration.
func get_input():
	input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * SPEED

	
func _physics_process(_delta):
	if is_multiplayer_authority():
		#if player_stats["health"] < player_stats["max_health"]:
			#player_stats["health"] += health_regen
		#%HealthBar.value = player_stats["health"]
		get_input()
		move_and_slide()
		#if player_stats["health"] <= 0.0:
		#health_depleted.emit()

		

#func exp_gain():
	#%LevelUpBar.value += exp_value
	#if %LevelUpBar.value == %LevelUpBar.max_value:
		#%SpellSelection.leveled_up()
		#%LevelUpBar.max_value += 4
		#%LevelUpBar.value = 0
		#player_level += 1
		#player_level_up.emit()
		
		
#func stat_gain():
	#%StatLevelUpBar.value += stat_value
	#if %StatLevelUpBar.value == %StatLevelUpBar.max_value:
		#%SkillSelection.upgrade_skill()
		#%StatLevelUpBar.max_value += 4
		#%StatLevelUpBar.value = 0
		

#func take_damage(mob_damage, delta):
	#var raw_damage_to_take = (mob_damage * (delta * 10)) # delta was too slow so multi to get it to be faster tick
	#var defense_modifier_to_damage = player_stats["defense"] * 0.01
	#var adjusted_damage = raw_damage_to_take - (raw_damage_to_take * defense_modifier_to_damage)
	#player_stats["health"] -= adjusted_damage 
	#%HealthBar.value = player_stats["health"]

#func increase_stats(skill_name: String, gain: int):
	#skill_name = skill_name.to_lower()
	#if skill_name == "health":
		#player_stats["max_health"] += gain
	#player_stats[skill_name] += gain

#func add_item_stats():
	#print("YAY NEW ITEM")
	
	
