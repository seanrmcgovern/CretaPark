extends Node2D


@onready var keyCardAnimatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audioStreamPlayer: AudioStreamPlayer = $AudioStreamPlayer
@onready var collectSound = preload("res://Sounds/collect-keycard.wav")

func _ready():
	audioStreamPlayer.stream = collectSound

func _on_area_2d_body_entered(body):
	if (body.name == Common.Body.PLAYER):
		# play sound effect
		Utils.duplicateAudioStreamPlayerForSingleUse(audioStreamPlayer)
		# animate keyCard and mark as collected
		keyCardAnimatedSprite.play(Common.SpriteAnimation.COLLECT)
		await keyCardAnimatedSprite.animation_finished
		var keyCards = get_tree().get_nodes_in_group("KeyCards")
		print_debug(keyCards.size())
		if (keyCards.size() == 1):
			print_debug("All keycards collected")
		self.queue_free()
