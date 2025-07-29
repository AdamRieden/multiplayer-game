extends Node2D

var player_level = 1
var max_exp = 1#4
var exp_value = 1

var Level

@export var spell_confirmation_count = 0
@export var player_count = 0
var selected_spells := {}  # Dictionary of player_id -> {spell: String}
var spellselection_dict := {}
var spellobjects_dict := {}

# Called when the node enters the scene tree for the first time.
func _ready():
	%EXPbar.max_value = max_exp
	%EXPbar.value = 0
	
	Level = get_tree().get_nodes_in_group("Level")[0]
	for child in $PlayerSpawnNode.get_child_count():
		spellselection_dict[$PlayerSpawnNode.get_child(child).player_id] = get_tree().get_nodes_in_group("SpellSelection")[child]
		spellobjects_dict[$PlayerSpawnNode.get_child(child).player_id] = get_tree().get_nodes_in_group("SpellObjects")
	
@rpc("any_peer")
func rpc_register_player():
	if multiplayer.is_server():
		player_count += 1
		print("Registered player. Total count: ", player_count)

func exp_increase():
	%EXPbar.value += exp_value
	if %EXPbar.value >= %EXPbar.max_value:
		if player_count == 0:
			print("Warning: player_count is still 0. Not leveling up.")
			return
		for key in spellselection_dict:
			var spellselection_node = spellselection_dict[key]
			spellselection_node.rpc("rpc_leveled_up")
			spellselection_node.rpc("rpc_show_spell_ui")

		pause_game()
		%EXPbar.value = 0
		%EXPbar.max_value += 0#4
		player_level += 1
		Level.player_level_up()

func update():
	for child in $PlayerSpawnNode.get_child_count():
		spellselection_dict[$PlayerSpawnNode.get_child(child).player_id] = get_tree().get_nodes_in_group("SpellSelection")[child]
		spellobjects_dict[$PlayerSpawnNode.get_child(child).player_id] = get_tree().get_nodes_in_group("SpellObjects")
		
func store_spell_choice(player_id: int, spell: String):
	selected_spells[player_id] = { "spell": spell}
	#print(player_id, " ", spell)
	spell_confirmation_count += 1
	#print("Current count: ", spell_confirmation_count, "/", player_count)
	for players in selected_spells:
		var path_for_players = "/root/Game/PlayerSpawnNode/"
		var new_path_for_player = path_for_players + str(players)
		var spellobjects_node = get_node(new_path_for_player + "/SpellObjects")
		if get_node(new_path_for_player).leveled_up != true:
			spellobjects_node.find_what_spell_to_spawn(spell)
			get_node(new_path_for_player).leveled_up = true

	if spell_confirmation_count == player_count:
		for key in spellselection_dict:
			var spellselection = spellselection_dict[key]
			spellselection.rpc("rpc_hide_spell_ui")
			spellselection.rpc("rpc_reset_clicks")
		for child in $PlayerSpawnNode.get_child_count():
			$PlayerSpawnNode.get_child(child).leveled_up = false

		start_game()
		selected_spells.clear()
		
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

	print("All players ready. Starting game...")
	rpc("rpc_unpause_game")
	spell_confirmation_count = 0

@rpc("any_peer", "call_local")
func rpc_unpause_game():
	get_tree().paused = false

