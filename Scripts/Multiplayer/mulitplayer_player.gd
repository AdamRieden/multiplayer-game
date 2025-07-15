extends CharacterBody2D

#signal health_depleted

@export var SPEED = 55
@export var player_id := 1:
	set(id):
		player_id = id
		%InputSynchronizer.set_multiplayer_authority(id)

@export var leveled_up = false
#MUST CHANGE THE VALUES IN THE PROGRESS BAR INSPECTOR TO ACTUALLY SEE CHANGE IN HEALTH MAX AND HEALTH VALUE
var max_stat = 1#4
var stat_value = 1

var player_stats = {"attack":5, "defense": 4, "health": 50.0, "max_health": 50.0}
var health_regen = .2 / player_stats["max_health"]

var input_direction
var game

	
func _ready():
	if multiplayer.get_unique_id() == player_id:
		$Camera2D.make_current()
		$Camera2D.zoom = Vector2(3.5, 3.5)
	else:
		$Camera2D.enabled = false
	game = get_tree().get_nodes_in_group("Game")[0]
	game.update()
	game.rpc("rpc_register_player")
	$SpellObjects.player_id = player_id
	$CanvasLayer/SpellSelection.player_id = player_id
	%HealthBar.max_value = player_stats["max_health"]
	%HealthBar.value = player_stats["health"]
	#%StatLevelUpBar.max_value = max_stat
	#%StatLevelUpBar.value = 0
	
# get the input direction and handle the movement/deceleration.
func get_input():
	input_direction = %InputSynchronizer.input_direction
	velocity = input_direction * SPEED

	
func _physics_process(_delta):
	if multiplayer.is_server():
		
		if player_stats["health"] < player_stats["max_health"]:
			player_stats["health"] += health_regen
		%HealthBar.value = player_stats["health"]
		get_input()
		move_and_slide()

		#if player_stats["health"] <= 0.0:
		#health_depleted.emit()

		

func exp_gain():
	print("OBTAINED")

		
#func stat_gain():
	#%StatLevelUpBar.value += stat_value
	#if %StatLevelUpBar.value == %StatLevelUpBar.max_value:
		#%SkillSelection.upgrade_skill()
		#%StatLevelUpBar.max_value += 4
		#%StatLevelUpBar.value = 0
		

func take_damage(mob_damage, _delta):
	#var raw_damage_to_take = (mob_damage * (delta * 10)) # delta was too slow so multi to get it to be faster tick
	#var defense_modifier_to_damage = player_stats["defense"] * 0.01
	#var adjusted_damage = raw_damage_to_take - (raw_damage_to_take * defense_modifier_to_damage)
	#player_stats["health"] -= adjusted_damage 
	player_stats["health"] -= mob_damage
	%HealthBar.value = player_stats["health"]

#func increase_stats(skill_name: String, gain: int):
	#skill_name = skill_name.to_lower()
	#if skill_name == "health":
		#player_stats["max_health"] += gain
	#player_stats[skill_name] += gain

#func add_item_stats():
	#print("YAY NEW ITEM")
	
	
