extends Control


var player 

var spell_tracker_dict = {1: -1, 2: -1, 3: -1, 4: -1, 5: -1, 6: -1, 7: -1, 8: -1}

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0] 

func find_open_spellslot(spell, i):
	for slot in spell_tracker_dict:
		if spell_tracker_dict[slot] == i:
			return add_spell_texture(spell, slot)
			
			
		elif spell_tracker_dict[slot] == -1:
			spell_tracker_dict[slot] = i
			return add_spell_texture(spell, slot)
			
			
func add_spell_texture(spell, i):
	var spell_box = %SpellSlotGrid.get_child(i-1) as TextureRect
	spell_box.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	spell_box.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	spell_box.texture = spell.spell_texture
