extends Node2D

var player_level = 1
var max_exp = 1#4
var exp_value = 1

var Level
var spellselection_array

@export var spell_confirmation_count = 0
@export var player_count = 0
@export var player_and_spell_selected = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	%EXPbar.max_value = max_exp
	%EXPbar.value = 0
	
	Level = get_tree().get_nodes_in_group("Level")[0]
	spellselection_array = get_tree().get_nodes_in_group("SpellSelection")
	
@rpc("any_peer")
func rpc_register_player():
	if multiplayer.is_server():
		player_count += 1
		print("Registered player. Total count: ", player_count)

#
#func exp_increase():
	#%EXPbar.value += exp_value
	#if %EXPbar.value == %EXPbar.max_value:
		#for i in range(0, $PlayerSpawnNode.get_child_count()):
			#spellselection_array[i].rpc("rpc_leveled_up")
			#spellselection_array[i].rpc("rpc_show_spell_ui")
		#%EXPbar.value = 0
		#%EXPbar.max_value += 4
		#player_level += 1
		#Level.player_level_up()
		#pause_game()
		
func exp_increase():
	%EXPbar.value += exp_value
	if %EXPbar.value >= %EXPbar.max_value:
		if player_count == 0:
			print("Warning: player_count is still 0. Not leveling up.")
			return

		for i in range(player_count):
			spellselection_array[i].rpc("rpc_leveled_up")
			spellselection_array[i].rpc("rpc_show_spell_ui")
		
		pause_game()
		%EXPbar.value = 0
		%EXPbar.max_value += 4
		player_level += 1
		Level.player_level_up()

func update():
	spellselection_array = get_tree().get_nodes_in_group("SpellSelection")

func spell_confirmation(player_id: int, selected_spell, selected_spell_level):
	player_and_spell_selected[player_id] = [selected_spell, selected_spell_level]
	spell_confirmation_count += 1
	print("Current count: ", spell_confirmation_count, "/", player_count)

	if spell_confirmation_count == player_count:
		#print("HURRAY - All players confirmed!")
		for i in range(player_count):
			spellselection_array[i].rpc("rpc_hide_spell_ui")
			#spellselection_array[i].rpc("set_up_spell")
		start_game()
	else:
		#print(player_count - spell_confirmation_count, " more players need to click confirm")
		pass
		
	
func pause_game():
	if multiplayer.is_server():
		rpc("rpc_pause_game")

@rpc("any_peer", "call_local")
func rpc_pause_game():
	get_tree().paused = true


@rpc("any_peer", "call_local")
func start_game():
	if !multiplayer.is_server():
		return  # Only the server continues past here

	#print("All players ready. Starting game...")
	rpc("rpc_unpause_game")
	spell_confirmation_count = 0

@rpc("any_peer", "call_local")
func rpc_unpause_game():
	#print("UNPAUSE GAEM")
	print(player_and_spell_selected, "   ARRAY FOR SPELLS LEAREND")
	get_tree().paused = false

