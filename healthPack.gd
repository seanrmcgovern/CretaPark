extends RigidBody2D

var collected: bool = false

@onready var healthPackAnimatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audioStreamPlayer: AudioStreamPlayer = $AudioStreamPlayer
@onready var collectSound = preload("res://Sounds/health-up.wav")

func _ready():
	audioStreamPlayer.stream = collectSound

func _on_area_2d_body_entered(body):
	if (body.name == Common.Body.PLAYER && !collected):
		Utils.increasePlayerHealth(1)
		# mark as collected
		collected = true
		# play sound effect
		Utils.duplicateAudioStreamPlayerForSingleUse(audioStreamPlayer)
		# animate keyCard and mark as collected
		healthPackAnimatedSprite.play(Common.SpriteAnimation.COLLECT)
		await healthPackAnimatedSprite.animation_finished
		self.queue_free()
