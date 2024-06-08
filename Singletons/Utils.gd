extends Node

# if actually releasing this game you should use: "users://savegame.bin"
# "users" works on windows, android, ios...
# should try using users as well
const SAVE_PATH = "res://savegame.bin"

func saveGame():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data: Dictionary = {
		"playerHP": Game.playerHP,
		"gold": Game.gold,
		"ammo": Game.ammo
	}
	var jstr = JSON.stringify(data)
	file.store_line(jstr)
	
func loadGame():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if FileAccess.file_exists(SAVE_PATH):
		if not file.eof_reached():
			var current_line = JSON.parse_string(file.get_line())
			if current_line:
				Game.playerHP = current_line["playerHP"]
				Game.gold = current_line["gold"]
				Game.ammo = current_line["ammo"]
	
func duplicateAudioStreamPlayerForSingleUse(audioStreamPlayer: AudioStreamPlayer) -> void:
	var newAudioPlayer: AudioStreamPlayer = audioStreamPlayer.duplicate()
	get_tree().root.add_child(newAudioPlayer)
	newAudioPlayer.play()
	await newAudioPlayer.finished
	newAudioPlayer.queue_free()
