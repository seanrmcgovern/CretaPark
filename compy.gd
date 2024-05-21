extends CharacterBody2D

# TODO:
# add state machine, chase state
# add outlines to compy run sprites
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
@onready var player: Player = get_node("../Player")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# handle chasing player
	if chase:
		var direction = (player.position - self.position).normalized()
		if direction.x > 0:
			compyAnimatedSprite.flip_h = true
		else:
			compyAnimatedSprite.flip_h = false
		velocity.x = direction.x * SPEED
		compyAnimatedSprite.play("Run")
	else:
		if compyAnimatedSprite.animation != "Death":
			compyAnimatedSprite.play("Idle")
		velocity.x = 0

	move_and_slide()

func _on_player_detection_body_entered(body):
	if body.name == Common.Body.PLAYER && compyAnimatedSprite.animation != "Death":
		chase = true

func _on_player_detection_body_exited(body):
	if body.name == Common.Body.PLAYER:
		chase = false

# detect damage from player attacks
func _on_projectile_detection_body_entered(body):
	if body.name == Common.Body.BULLET && dinoHealth > 0:
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
func death():
	Game.gold += 5
	Utils.saveGame()
	chase = false
	# use the below line if we want player collisions with dinos
	#get_node("CollisionShape2D").set_deferred("disabled", true)
	compyAnimatedSprite.play("Death")
	await compyAnimatedSprite.animation_finished
	self.queue_free()
