extends Node2D

@onready var spell_spawner = $SpellSpawner

@export var player_id : int

var sword_spawn
var sword_level = 1
var circle_spawn
var circle_level = 1

func _ready():
	player_id = multiplayer.get_unique_id()

func update_items_for_spells(spell_level: int):
	var spell_item_list = self.get_child(spell_level).get_child(0)
	print(spell_item_list)
	if spell_item_list != null:
		for item in spell_item_list.get_child_count():
			spell_item_list.get_child(item).update()
			
			
func find_what_spell_to_spawn(spell: String, selected_spell_level: int):
	print(spell, " ", selected_spell_level)
	if spell == "Wind Sword":
		spawn_sword(spell)#, selected_spell_level)
	if spell == "Resonating Circles":
		spawn_circles(spell)#, selected_spell_level)
	
	
func spawn_sword(spell: String):#, selected_spell_level: int):
	if sword_level == 1:
		var sword = spell_spawner.get_spawnable_scene(0)
		sword_spawn = load(sword).instantiate()
		
		var sword_spell_res = load(SpellDictionary.spell_library[spell][sword_level])
		sword_spawn.SpellResource = sword_spell_res
		sword_spawn.player = get_parent()
		$Spell1.add_child(sword_spawn, true)
		sword_level += 1
		
	elif sword_level == 2:
		var level_2_res = load(SpellDictionary.spell_library[spell][sword_level])
		sword_spawn.SpellResource = level_2_res

func spawn_circles(spell: String):#, selected_spell_level: int):
	if circle_level == 1:
		var circle = spell_spawner.get_spawnable_scene(1)
		circle_spawn = load(circle).instantiate()
		
		var circle_spell_res = load(SpellDictionary.spell_library[spell][circle_level])
		circle_spawn.SpellResource = circle_spell_res
		circle_spawn.player = get_parent()
		
		$Spell2.add_child(circle_spawn, true)
		circle_level += 1
		
	elif circle_level == 2:
		circle_spawn.SpellResource = load(SpellDictionary.spell_library[spell][circle_level])

