extends Control

@export var player_id : int

var spell_click_monitor = [null, null]
var confirm_click_monitor = false
var current_spell_res = null
var selected_spell = null
var selected_spell_level = null
var spell_texture_box

var game
var player
var spellobjects
var profile
var spells_learned 

var learned_spell_dims_with_book := {"position": Vector2(1429, 294), "columns": 2, "h_separation": 32, "v_separation": 32}
var learned_spell_dims_idle := {"position": Vector2(10, 260), "columns": 2, "h_separation": 1688, "v_separation": 20}

func _ready():
	player = get_parent().get_parent()
	game = get_tree().get_nodes_in_group("Game")[0]
	spellobjects = player.get_node("SpellObjects")
#	profile = get_tree().get_nodes_in_group("Profile")[0]
	spells_learned = player.get_node("CanvasLayer/SpellsLearned")
	move_learned_spells_next_to_edge()
	rpc_hide_spell_ui()
	load_firstlevel_spells()
	spell_texture_box = self.get_node("SpellRect") as TextureRect
	player_id = multiplayer.get_unique_id()


@rpc("any_peer", "call_local")
func rpc_show_spell_ui():
	self.visible = true
	
@rpc("any_peer", "call_local")
func rpc_hide_spell_ui():
	self.visible = false
	
	
@rpc("any_peer", "call_local")
func rpc_leveled_up():
	leveled_up()

func leveled_up():
	reset_book()
	move_learned_spells_next_to_book()
	rpc_show_spell_ui()
	#profile._show()
	
func move_learned_spells_next_to_book():
	spells_learned.position = learned_spell_dims_with_book["position"]
	spells_learned.get_child(0).columns = learned_spell_dims_with_book["columns"]
	spells_learned.get_child(0).add_theme_constant_override("h_separation", learned_spell_dims_with_book["h_separation"])
	spells_learned.get_child(0).add_theme_constant_override("v_separation", learned_spell_dims_with_book["v_separation"]) 
	
func spell_chosen():
	self.visible = false
	move_learned_spells_next_to_edge()
	#profile._hide()
	
func move_learned_spells_next_to_edge():
	spells_learned.position = learned_spell_dims_idle["position"]
	spells_learned.get_child(0).columns = learned_spell_dims_idle["columns"]
	spells_learned.get_child(0).add_theme_constant_override("h_separation", learned_spell_dims_idle["h_separation"])
	spells_learned.get_child(0).add_theme_constant_override("v_separation", learned_spell_dims_idle["v_separation"])  
	

	
# ----------------------ALL SPELL RELATED FUNCTIONS----------------------
func load_firstlevel_spells():
	for i in range(0,7):
		# loading spell resource
		connect_spell_buttons(i)

func connect_spell_buttons(i: int):#, spell_resource: Resource):
	if i == 0:
		%Spell1.pressed.connect(spell1.bind(load(SpellDictionary.spell_library["Wind Sword"][1])))
	if i == 1:
		%Spell2.pressed.connect(spell2.bind(load(SpellDictionary.spell_library["Resonating Circles"][1])))
	#if i == 2:
		#%Spell3.pressed.connect(spell3.bind(spell_resource))
	#if i == 3:
		#%Spell4.pressed.connect(spell4.bind(spell_resource))
	#if i == 4:
		#%Spell5.pressed.connect(spell5.bind(spell_resource))
	#if i == 5:
		#%Spell6.pressed.connect(spell6.bind(spell_resource))
	#if i == 6:
		#%Spell7.pressed.connect(spell7.bind(spell_resource))
	#if i == 7:
		#%Spell8.pressed.connect(spell8.bind(spell_resource))


func load_spell_content_on_book(spell_resource: Resource):
	spell_texture_box.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	spell_texture_box.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	
	# the first click, so technically this should not turn the page
	if spell_click_monitor[0] == null:
		which_spell_resource_to_load_for_book(spell_texture_box, spell_resource)

	else:
		# if the user clicks on the same spell, doesn't cause the book to flip to the same page
		if spell_click_monitor[0] != spell_click_monitor[1]:
			# resets all changing icon and texts to look like the page was turned
			reset_book()
			%SpellBook.play("default")
			await %SpellBook.animation_finished
			which_spell_resource_to_load_for_book(spell_texture_box, spell_resource)



func which_spell_resource_to_load_for_book(texture_box, spell):
	%SpellTextName.text = "[center]%s[/center]" % spell.spell_name
	%SpellDescription.text = "[center]%s[/center]" % spell.description
	%SpellBuffText.text = "[center]%s[/center]" % SpellDictionary.spell_buff_texts[spell.spell_name]
	texture_box.texture = spell.spell_texture
	
func reset_book():
	%SpellBuffText.text = ""
	%SpellTextName.text = ""
	%SpellDescription.text = ""
	spell_texture_box.texture = null
	
# ----------------- Spell Buttons ----------------- #
func spell1(spell_resource: Resource):
	one_click_spell("Wind Sword", spell_resource)
	load_spell_content_on_book(spell_resource)


func spell2(spell_resource: Resource):
	one_click_spell("Resonating Circles", spell_resource)
	load_spell_content_on_book(spell_resource)


func spell3(spell_resource: Resource):
	one_click_spell("Spartan Horn", spell_resource)
	load_spell_content_on_book(spell_resource)


func spell4(spell_resource: Resource):
	one_click_spell("Spell4", spell_resource)
	load_spell_content_on_book(spell_resource)


func spell5(spell_resource: Resource):
	one_click_spell("Spell5", spell_resource)
	load_spell_content_on_book(spell_resource)


func spell6(spell_resource: Resource):
	one_click_spell("Spell6", spell_resource)
	load_spell_content_on_book(spell_resource)

		
func spell7(spell_resource: Resource):
	one_click_spell("Spell7", spell_resource)
	load_spell_content_on_book(spell_resource)

		
func spell8(spell_resource: Resource):
	one_click_spell("Spell8", spell_resource)
	load_spell_content_on_book(spell_resource)
	

# When confirm button is pressed, calls rpc function to let all other clients know a player is ready.
# Rejects when a spell is not selected 
func _on_confirm_pressed():
	if spell_click_monitor[1] != null:
		rpc("rpc_spell_selected", selected_spell, selected_spell_level)
		disableenable_buttons(true)
	else:
		print("No spell selected")
	

# Checks if the spell is valid, then calls the game to confirm what spell the player has selected and the level of the spell
@rpc("any_peer", "call_local")
func rpc_spell_selected(selected_spell_string: String, spell_level: int):
	if selected_spell_string == null or selected_spell_string == "":
		print("Please select a spell, then click confirm")
	else:
		var sender_id = multiplayer.get_remote_sender_id()
		game.store_spell_choice(sender_id, selected_spell_string, spell_level)

# Tracks multiple variables of the selected spell resource for uses in other functions
# as well as tracks the different clicks of the spells
func one_click_spell(spell: String, spell_resource: Resource):
	current_spell_res = spell_resource
	selected_spell = current_spell_res.spell_name
	selected_spell_level = current_spell_res.spell_level

	var temp = spell_click_monitor[1]
	spell_click_monitor[1] = spell
	spell_click_monitor[0] = temp
	
# resets the spell click monitor and confirm button click
@rpc("any_peer", "call_local")
func rpc_reset_clicks():
	spell_click_monitor = [null,null]
	confirm_click_monitor = false
	disableenable_buttons(false)
	
# disables all buttons
func disableenable_buttons(boolean):
	%Spell1.disabled = boolean
	%Spell2.disabled = boolean
	%Spell3.disabled = boolean
	%Spell4.disabled = boolean
	%Spell5.disabled = boolean
	%Spell6.disabled = boolean
	%Spell7.disabled = boolean
	%Spell8.disabled = boolean
	%Confirm.disabled = boolean
