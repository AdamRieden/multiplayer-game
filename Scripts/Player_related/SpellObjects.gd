extends Node2D

@onready var spell_spawner = $SpellSpawner

@export var player_id : int

var sword_spawn
var sword_level_tracker = 0
var circle_spawn
var circle_level_tracker = 0
var horn_spawn
var horn_level_tracker = 0


func _ready():
	player_id = multiplayer.get_unique_id()

func update_items_for_spells(spell_level: int):
	var spell_item_list = self.get_child(spell_level).get_child(0)
	print(spell_item_list)
	if spell_item_list != null:
		for item in spell_item_list.get_child_count():
			spell_item_list.get_child(item).update()
			
			
func find_what_spell_to_spawn(spell: String):
	#print(spell, " ", selected_spell_level)
	if spell == "Wind Sword":
		spawn_sword(spell)
	if spell == "Resonating Circles":
		spawn_circles(spell)
	if spell == "Spartan Horn":
		spawn_horn(spell)

	
func spawn_sword(spell: String):
	if sword_level_tracker == 0:
		var sword = spell_spawner.get_spawnable_scene(0)
		sword_spawn = load(sword).instantiate()
		
		var sword_spell_res = load(SpellDictionary.spell_library[spell]["Base"])
		sword_spawn.SpellResource = sword_spell_res
		sword_spawn.player = get_parent()
		$Spell1.add_child(sword_spawn, true)
		sword_level_tracker += 1
		
	elif sword_level_tracker == 1:
		var raw_path = SpellDictionary.spell_library[spell]["Raw"]
		var base_res = load(raw_path)
		var sword_spell_res = base_res.duplicate(true) # Deep copy
		
		# Now can customize the duplicated resource so can't be referenced by any other player
		sword_spell_res.attack = 4 + sword_level_tracker * 2
		sword_spawn.SpellResource = sword_spell_res
		sword_level_tracker += 1
	
func spawn_circles(spell: String):
	if circle_level_tracker == 0:
		var circle = spell_spawner.get_spawnable_scene(1)
		circle_spawn = load(circle).instantiate()
		
		var circle_spell_res = load(SpellDictionary.spell_library[spell]["Base"])
		circle_spawn.SpellResource = circle_spell_res
		circle_spawn.player = get_parent()
		
		$Spell2.add_child(circle_spawn, true)
		circle_level_tracker += 1
		
	elif circle_level_tracker >= 1:
		var raw_path = SpellDictionary.spell_library[spell]["Raw"]
		var base_res = load(raw_path)
		var circle_spell_res = base_res.duplicate(true) # Deep copy

		# Now can customize the duplicated resource so can't be referenced by any other player
		circle_spell_res.speed += (5 * circle_level_tracker)
		circle_spawn.SpellResource = circle_spell_res
		circle_level_tracker += 1



func spawn_horn(spell: String):
	if horn_level_tracker == 0:
		var horn = spell_spawner.get_spawnable_scene(2)
		horn_spawn = load(horn).instantiate()
		
		var horn_spell_res = load(SpellDictionary.spell_library[spell]["Base"])
		horn_spawn.SpellResource = horn_spell_res
		horn_spawn.player = get_parent()
		$Spell3.add_child(horn_spawn, true)
		horn_level_tracker += 1
		
	elif horn_level_tracker == 1:
		var raw_path = SpellDictionary.spell_library[spell]["Raw"]
		var base_res = load(raw_path)
		var horn_spell_res = base_res.duplicate(true) # Deep copy
		
		# Now can customize the duplicated resource so can't be referenced by any other player
		horn_spell_res.attack = 4 + horn_level_tracker * 2
		horn_spawn.SpellResource = horn_spell_res
		horn_level_tracker += 1
		
		
		
