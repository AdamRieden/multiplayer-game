extends Node2D



func update_items_for_spells(spell_level: int):
	var spell_item_list = self.get_child(spell_level).get_child(0)
	print(spell_item_list)
	if spell_item_list != null:
		for item in spell_item_list.get_child_count():
			spell_item_list.get_child(item).update()
