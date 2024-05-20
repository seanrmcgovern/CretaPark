extends Label

@export var player: Player

func _process(delta):
	text = "Direction: " + str(player.direction).pad_decimals(2)

