extends StatusEffects

class_name Stun

func _init(time):
	super._init(time)
	effect_name = "stun"
	
func apply(target):
	super.apply(target)
	target.ChangingSpeed = 0
	target.stun = true
	
func remove(target):
	super.remove(target)
	target.ChangingSpeed = target.SPEED
	target.stun = false
