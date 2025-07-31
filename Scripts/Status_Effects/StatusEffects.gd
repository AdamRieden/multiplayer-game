extends Resource
class_name StatusEffects

var duration: float
var effect_name: String
var dot_boolean: bool

func _init(time):
	duration = time

	
func get_class_name():
	return effect_name
	
func get_dot_bool():
	return dot_boolean
	
func apply(_target):
	pass
	#print("added ", effect_name," to ", target)
	#would also play target animation for that specific status
	
func remove(_target):
	pass
	#print("removed ", effect_name," from ", target)
	#would also play target animation for that specific status
