extends TileMap

var DarkAngelSpawners
var mob_spawn_time = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	DarkAngelSpawners = get_tree().get_nodes_in_group("DarkAngelSpawn")
	update_spawn_timers(mob_spawn_time)

func update_spawn_timers(new_time):
	for spawners in DarkAngelSpawners:
		spawners.waittime = 4
		


func player_level_up():
	# Reduce spawn time, but cap it at a minimum value
	mob_spawn_time -= .5
	update_spawn_timers(mob_spawn_time)
	#if player_level == 2:
		#spawnBoss.emit()
