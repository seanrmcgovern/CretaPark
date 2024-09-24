extends CharacterBody2D

#TODO: Look into pause menu/functionality

const SPEED:float = 75.0

# direction is an export var
# which allows us to set the inital direction a protoceratops
# should be going, which simplifies the logic for movement
# allow integer values from 0 to 20, and snap the value to multiples of 2
# effectively limiting the possible values to -1 and 1, for velocity.x
# also setting default value to -1, so the dino will move left by default initially
# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
@export_range(-1, 1, 2) var direction: int = -1

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var dinoHealth: int = 4
var lastPosition: float = 0

@onready var protoAnimatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitFlashAnimPlayer: AnimationPlayer = $HitFlashAnimationPlayer
@onready var hazardAreaCollisionShape: CollisionShape2D = $HazardArea/CollisionShape2D
@onready var despawnAudioStreamPlayer: AudioStreamPlayer = $DespawnAudioStreamPlayer
@onready var overworldDetection1: Area2D = $OverworldDetection1
@onready var overworldDetection2: Area2D = $OverworldDetection2
@onready var despawnSound = preload("res://Sounds/despawn.wav")
@onready var player: Player = get_node("../Player")

func _ready():
	despawnAudioStreamPlayer.stream = despawnSound
	pass
	
func _physics_process(delta):
	if protoAnimatedSprite.animation != Common.SpriteAnimation.DEATH:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta

		# protoceratops will pace back and forth
		if !Game.playerStateMachine.currentState is PausedState:
			velocity.x = direction * SPEED
			protoAnimatedSprite.play(Common.SpriteAnimation.RUN)
		else:
			protoAnimatedSprite.play(Common.SpriteAnimation.IDLE)
			velocity.x = 0

	move_and_slide()


func _on_projectile_detection_body_entered(body):
	if body.name == Common.Body.BULLET && dinoHealth > 0:
		# prevent bullet from colliding during animation
		body.get_node("BulletCollision").set_deferred("disabled", true)
		# deduct health
		dinoHealth -= 1
		# check for dino elimination
		if dinoHealth <= 0:
			death()
		else:
			# add flicker effect
			hitFlashAnimPlayer.play("HitFlash")
			pass
			
func death() -> void:
	velocity.x = 0
	Game.gold += 10
	Utils.saveGame()
	# play sound effect
	Utils.duplicateAudioStreamPlayerForSingleUse(despawnAudioStreamPlayer)
	# disale hazard area collision shape so player does not take damage during animation
	hazardAreaCollisionShape.set_deferred("disabled", true)
	protoAnimatedSprite.play(Common.SpriteAnimation.DEATH)
	await protoAnimatedSprite.animation_finished
	self.queue_free()

func reverseDirection() -> void:
	direction *= -1
	protoAnimatedSprite.flip_h = !protoAnimatedSprite.flip_h

func _on_overworld_detection_1_body_entered(body):
	if direction == -1:
		reverseDirection()


func _on_overworld_detection_2_body_entered(body):
	if direction == 1:
		reverseDirection()
