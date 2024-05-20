extends Label

@export var player: Player

func _process(delta):
	text = "VelocityX: " + str(player.velocity.x).pad_decimals(2)
