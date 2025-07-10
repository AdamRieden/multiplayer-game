extends Control


var spells_to_load := [
	"res://Resources/Spells/WindSword1.tres",
	"res://Resources/Spells/ResonatingCircles1.tres",
	"res://Resources/Spells/SpartanHorn1.tres"#,
	#"res://Resources/Spells/PrototypeShield1.tres",
	#"res://Resources/Spells/EyeOfGorgon1.tres",
	#"res://Resources/Spells/MoonFriend1.tres",
	#"res://Resources/Spells/PowerOfTheSunPeople1.tres",
	#"res://Resources/Spells/Watcher1.tres"
]

var spell_click_monitor = [null, null]
var confirm_click_monitor = false
var current_spell_res = null
var selected_spell = null
var selected_spell_level = null
var spell_confirmed = false
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
	for i in spells_to_load.size():
		# loading spell resource
		var spell_loader = load(spells_to_load[i])
		
		#OUTDATED, JUST ADDED THE IMAGE INTO THE TEXTURE
		## setting up the spell book texture
		#var spell_texture = self.get_child(i+1).get_child(0) as TextureRect
		#spell_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		#spell_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		#spell_texture.texture = spell_loader.spell_book_texture
		
		connect_spell_buttons(i, spell_loader)

func connect_spell_buttons(i: int, spell_resource: Resource):
	if i == 0:
		%Spell1.pressed.connect(spell1.bind(spell_resource))
	if i == 1:
		%Spell2.pressed.connect(spell2.bind(spell_resource))
	if i == 2:
		%Spell3.pressed.connect(spell3.bind(spell_resource))
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


func load_first_spell(spell_resource: Resource, i: int):
	var instantiate = load(spell_resource.spell_instantiation)
	var new_spell = instantiate.instantiate()
	new_spell.SpellResource = spell_resource
	spells_learned.find_open_spellslot(new_spell.SpellResource, i)
	spellobjects.get_child(i-1).add_child(new_spell)
	#load_next_spell_resource_icon_for_book(new_spell.SpellResource.next_spell_resource, button_name)
	
func load_next_leveled_spell(button_name, i: int):
	var delete_node = spellobjects.get_child(i-1).get_child(1)

	var instantiate = load(delete_node.SpellResource.next_spell_instantiation)
	var new_spell = instantiate.instantiate()
	
	new_spell.SpellResource = ResourceLoader.load(delete_node.SpellResource.next_spell_resource)
	spells_learned.find_open_spellslot(new_spell.SpellResource, i)
	
	spellobjects.get_child(i-1).remove_child(delete_node)
	spellobjects.get_child(i-1).add_child(new_spell)
	spellobjects.update_items_for_spells(i-1)
	#if new_spell.SpellResource.next_spell_resource != "null":
		#load_next_spell_resource_icon_for_book(new_spell.SpellResource.next_spell_resource, button_name)
	#else:
		#button_name.disabled = true
	if new_spell.SpellResource.next_spell_resource == "null":
		button_name.disabled = true


#OUTDATED BUT CAN BE USEFUL TO LOOK AT FOR GUIDANCE
#func load_next_spell_resource_icon_for_book(next_spell: String, button_name):
	#var spell = load(next_spell)
	## if the texture of the actual spell changes for the book
	#var spell_texture = button_name.get_child(0) as TextureRect
	#spell_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	#spell_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	#spell_texture.texture = spell.spell_texture

	
func load_spell_content_on_book(spell_resource: Resource, i: int):
	var next_spell
	
	spell_texture_box.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	spell_texture_box.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	
	# if this isn't a new spell, can load and use data of the next spell in line
	if spellobjects.get_child(i-1).get_child_count() > 1:
		next_spell = load(spellobjects.get_child(i-1).get_child(1).SpellResource.next_spell_resource)

	# the first click, so technically this should not turn the page
	if spell_click_monitor[0] == null:
		# basically if its the first spell so only the resource is available
		if next_spell == null:
			which_spell_resource_to_load_for_book(spell_texture_box, spell_resource)
		else:
			which_spell_resource_to_load_for_book(spell_texture_box, next_spell)

	else:
		# resets all changing icon and texts to look like the page was turned
		reset_book()
		%SpellBook.play("default")
		await %SpellBook.animation_finished
		if next_spell == null:
			which_spell_resource_to_load_for_book(spell_texture_box, spell_resource)
		else:
			which_spell_resource_to_load_for_book(spell_texture_box, next_spell)


func which_spell_resource_to_load_for_book(texture_box, spell):
	%SpellTextName.text = "[center]%s[/center]" % spell.spell_name
	%SpellDescription.text = "[center]%s[/center]" % spell.description
	texture_box.texture = spell.spell_texture
	
func reset_book():
	%SpellBuffNerfText.text = ""
	%SpellTextName.text = ""
	%SpellDescription.text = ""
	spell_texture_box.texture = null
	
# ----------------- Spell Buttons ----------------- #
func spell1(spell_resource: Resource):
	one_click_spell("Spell1", spell_resource)
	load_spell_content_on_book(spell_resource, 1)



func spell2(spell_resource: Resource):
	one_click_spell("Spell2", spell_resource)
	load_spell_content_on_book(spell_resource, 2)


		
func spell3(spell_resource: Resource):
	one_click_spell("Spell3", spell_resource)
	load_spell_content_on_book(spell_resource, 3)


func spell4(spell_resource: Resource):
	one_click_spell("Spell4", spell_resource)
	load_spell_content_on_book(spell_resource, 4)


func spell5(spell_resource: Resource):
	one_click_spell("Spell5", spell_resource)
	load_spell_content_on_book(spell_resource, 5)


func spell6(spell_resource: Resource):
	one_click_spell("Spell6", spell_resource)
	load_spell_content_on_book(spell_resource, 6)

		
func spell7(spell_resource: Resource):
	one_click_spell("Spell7", spell_resource)
	load_spell_content_on_book(spell_resource, 7)

		
func spell8(spell_resource: Resource):
	one_click_spell("Spell8", spell_resource)
	load_spell_content_on_book(spell_resource, 8)


@rpc("any_peer", "call_local")
func spellNumberSelected(SpellString: String):
	var spellNumberChar = int(SpellString.trim_prefix("spell"))
	
	# if spell # has not been added yet
	if spellobjects.get_child(spellNumberChar - 1).get_child_count() == 1:
		load_first_spell(current_spell_res, spellNumberChar)
		
	# if spell # has already been chosen
	else:
		load_next_leveled_spell(get_node(SpellString), spellNumberChar)
		
	reset_clicks()
	
func _on_confirm_pressed():
	if spell_click_monitor[1] != null:
		rpc("rpc_spell_selected", spell_click_monitor[1])
		#rpc_id(multiplayer.get_unique_id(), "rpc_spell_selected", spell_click_monitor[1])

	else:
		print("No spell selected")
	
	
@rpc("any_peer", "call_local")
func rpc_spell_selected(selected_spell_string: String):
	if selected_spell_string == null or selected_spell_string == "":
		print("Please select a spell, then click confirm")
		spell_confirmed = false
	else:
		var player_id = multiplayer.get_unique_id()
		#print("Player ", player_id, " selected ", selected_spell, " at level ", selected_spell_level)
		
		
		game.spell_confirmation(player_id, selected_spell, selected_spell_level)
		spell_confirmed = true


func set_up_spell():
	if spell_confirmed == true:
		disable_buttons()
		spellNumberSelected(spell_click_monitor[1]) 

func one_click_spell(spell: String, spell_resource: Resource):
	current_spell_res = spell_resource
	selected_spell = current_spell_res.spell_name
	selected_spell_level = current_spell_res.spell_level
		
	print("CURRENT SPELL RESOURCE ",current_spell_res, " selected_spell RAWWW, ", selected_spell)
	print(spell)
	var temp = spell_click_monitor[1]
	spell_click_monitor[1] = spell
	spell_click_monitor[0] = temp
	
func reset_clicks():
	spell_click_monitor = [null,null]
	confirm_click_monitor = false
	
func disable_buttons():
	%Spell1.disabled = true
	%Spell2.disabled = true
	%Spell3.disabled = true
	%Spell4.disabled = true
	%Spell5.disabled = true
	%Spell6.disabled = true
	%Spell7.disabled = true
	%Spell8.disabled = true
	%Confirm.disabled = true
