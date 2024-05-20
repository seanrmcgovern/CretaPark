extends Node2D

func _ready():
	# Utils.saveGame()
	Utils.loadGame()

func _on_quit_pressed():
	get_tree().quit()

func _on_play_pressed():
	if Game.playerHP <= 0:
		Game.playerHP = 10
		Game.gold = 0
		Game.ammo = Game.defaultStartingAmmo
		Utils.saveGame()
		
	if Game.ammo <= 4:
		Game.ammo = Game.defaultStartingAmmo
	get_tree().change_scene_to_file("res://world.tscn")
