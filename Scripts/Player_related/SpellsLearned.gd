extends Control


var player 
var player_id

var spell_tracker_dict = {1: -1, 2: -1, 3: -1, 4: -1, 5: -1, 6: -1, 7: -1, 8: -1}

func _ready():
	player = get_parent().get_parent()

# searches through the dictionary to see what slot hasn't been taken by a spell,
# and if that spell has already been learned, then return nothing cause there's nothing to add
func find_open_spellslot(spell):
	for slot in spell_tracker_dict:
		# if the spell slot hasn't been taken yet by another spell
		if typeof(spell_tracker_dict[slot]) != TYPE_STRING:
		
			if spell_tracker_dict[slot] == -1:
				spell_tracker_dict[slot] = spell
				
				return add_spell_texture(spell, slot)
		
		# if spell already learned, then exit func
		elif spell_tracker_dict[slot] == spell:
			return
			
# adds the spells texture to the box
func add_spell_texture(spell, i):

	var spell_box = %SpellSlotGrid.get_child(i-1) as TextureRect
	spell_box.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	spell_box.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	var spell_res_base = load(SpellDictionary.spell_library[spell]["Base"])
	var spell_copy = spell_res_base.duplicate(true)

	spell_box.texture = spell_copy.spell_texture
