extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var dinoHealth = 10
var brian
var chase = false

@onready var hpLabel = $HPLabel

@onready var hitFlashAnimPlayer = $HitFlashAnimationPlayer

func _ready():
	get_node("AnimatedSprite2D").play("Idle")


func _physics_process(delta):
	hpLabel.text = "HP: " + str(dinoHealth)
	
	velocity.y += gravity * delta
	if chase:
		#if get_node("AnimatedSprite2D").animation != "Death":
			#get_node("AnimatedSprite2D").play("Jump")
		#player = get_node("../../Player/Player")
		#var direction = (player.position - self.position).normalized()
		#if direction.x > 0:
			#get_node("AnimatedSprite2D").flip_h = true
		#else:
			#get_node("AnimatedSprite2D").flip_h = false
		#velocity.x = direction.x * SPEED
		pass
	else:
		if get_node("AnimatedSprite2D").animation != "Death":
			get_node("AnimatedSprite2D").play("Idle")
		velocity.x = 0

	move_and_slide()


func _on_object_collision_body_entered(body):
	if body.name == "Bullet" && dinoHealth > 0:
		body.get_node("BulletCollision").set_deferred("disabled", true) 
		# add flicker effect
		hitFlashAnimPlayer.play("HitFlash")
		# deduct health
		dinoHealth -= 2
		# check for dino elimination
		if dinoHealth <= 0:
			death()
			
			
func death():
	Game.gold += 5
	Utils.saveGame()
	# chase = false
	get_node("DinoFrogCollisionShape2D").set_deferred("disabled", true)
	get_node("AnimatedSprite2D").play("Death")
	await get_node("AnimatedSprite2D").animation_finished
	self.queue_free()
