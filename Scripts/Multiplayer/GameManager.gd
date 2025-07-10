extends Node



func _ready():
	if OS.has_feature("dedicated_server"):
		print("Starting dedicated server...")
		MultiplayerManager.become_host()



func _on_host_pressed():
	print("Become host")
	%MultiplayerHUD.hide()
	MultiplayerManager.become_host()



func _on_join_pressed():
	print("Join as player 2")
	%MultiplayerHUD.hide()
	MultiplayerManager.join_as_player_2()
