extends CharacterBody2D

# TODO:
# tip of compy not detecting damage
# bullet collides with explosion animation
# add state machine, chase state
# could have dinos drop randomized amount of bones or other materials
# could drop randomized types of bones, meant to inspire the player to collect
# the entire fossil

const SPEED: float = 100.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var dinoHealth: int = 2
var chase: bool = false

# should be using onready var mynode = $MyNode to cache the references, 
# which is faster than getting the nodes each frame, it makes a bigger difference than the NodePaths alone
@onready var hitFlashAnimPlayer: AnimationPlayer = $HitFlashAnimationPlayer
@onready var compyAnimatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hazardAreaCollisionShape: CollisionShape2D = $HazardArea/CollisionShape2D
@onready var despawnAudioStreamPlayer: AudioStreamPlayer = $DespawnAudioStreamPlayer
@onready var despawnSound = preload("res://Sounds/despawn.wav")
@onready var player: Player = get_node("../Player")

func _ready():
	despawnAudioStreamPlayer.stream = despawnSound

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# handle chasing player
	if chase && !Game.playerStateMachine.currentState is PausedState:
		var direction = (player.position - self.position).normalized()
		if direction.x > 0:
			compyAnimatedSprite.flip_h = true
		else:
			compyAnimatedSprite.flip_h = false
		velocity.x = direction.x * SPEED
		compyAnimatedSprite.play(Common.SpriteAnimation.RUN)
	else:
		if compyAnimatedSprite.animation != Common.SpriteAnimation.DEATH:
			compyAnimatedSprite.play(Common.SpriteAnimation.IDLE)
		velocity.x = 0

	move_and_slide()

func _on_player_detection_body_entered(body):
	if body.name == Common.Body.PLAYER && compyAnimatedSprite.animation != Common.SpriteAnimation.DEATH:
		chase = true

func _on_player_detection_body_exited(body):
	if body.name == Common.Body.PLAYER:
		chase = false

# detect damage from player attacks
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

# should make an enemy parent class with this function
# gold could be a parameter
func death() -> void:
	Game.gold += 5
	Utils.saveGame()
	chase = false
	# play sound effect
	Utils.duplicateAudioStreamPlayerForSingleUse(despawnAudioStreamPlayer)
	# disale hazard area collision shape so player does not take damage during animation
	hazardAreaCollisionShape.set_deferred("disabled", true)
	compyAnimatedSprite.play(Common.SpriteAnimation.DEATH)
	await compyAnimatedSprite.animation_finished
	self.queue_free()
