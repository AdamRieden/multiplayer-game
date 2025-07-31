extends Node

@export var spell_library := {
	"Wind Sword": {"Base": "res://Resources/Spells/WindSword/WindSwordBase.tres", "Raw": "res://Resources/Spells/WindSword/WindSwordRaw.tres"},
	"Resonating Circles": {"Base": "res://Resources/Spells/ResonatingCircles/ResonatingCirclesBase.tres", "Raw": "res://Resources/Spells/ResonatingCircles/ResonatingCirclesRaw.tres"},
	"Spartan Horn": {"Base": "res://Resources/Spells/SpartanHorn/SpartanHornBase.tres", "Raw": "res://Resources/Spells/SpartanHorn/SpartanHornRaw.tres"},
	"Prototype Shield" : {"Base": "res://Resources/Spells/PrototypeShield/PrototypeShieldBase.tres", "First": "res://Resources/Spells/PrototypeShield/PrototypeShield1.tres", 
			"Second": "res://Resources/Spells/PrototypeShield/PrototypeShield2.tres", "Third": "res://Resources/Spells/PrototypeShield/PrototypeShield3.tres",
			"Fourth": "res://Resources/Spells/PrototypeShield/PrototypeShield4.tres", "Raw": "res://Resources/Spells/PrototypeShield/PrototypeShieldRaw.tres" }
}

@export var spell_buff_texts := {
	"Wind Sword": "1: New Spell:\n Attack = 1\nEvery Next Level:\nAttack += 2", 
	"Resonating Circles": "1: New Spell:\n Attack = 1, Speed = 5\nEvery Next Level:\nAttack += 1, Speed += 5",
	"Spartan Horn": "1: New Spell:\n Attack = 0.05, Cooldown = 10s, Duration = 2s\nEvery Next Level:\nAttack += 0.03, Cooldown -= .75s, Duration += .2s",
	"Prototype Shield": "1: New Spell:\n + First Shield, Cooldown = 2s\n2: + Second Shield, Cooldown = 3s\n3: + Third Shield, Cooldown = 4s\n4: + Fourth Shield, Cooldown = 5s\nEvery Next Level: Cooldown -= .2s For All Shields"
}
