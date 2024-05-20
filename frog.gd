extends CharacterBody2D

var SPEED = 50
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var dinoHealth = 10

var player

var chase = false

func _ready():
	get_node("AnimatedSprite2D").play("Idle")

func _physics_process(delta):
	# Gravity for frog
	velocity.y += gravity * delta
	if chase:
		if get_node("AnimatedSprite2D").animation != "Death":
			get_node("AnimatedSprite2D").play("Jump")
		player = get_node("../../Player/Player")
		var direction = (player.position - self.position).normalized()
		if direction.x > 0:
			get_node("AnimatedSprite2D").flip_h = true
		else:
			get_node("AnimatedSprite2D").flip_h = false
		velocity.x = direction.x * SPEED
	else:
		if get_node("AnimatedSprite2D").animation != "Death":
			get_node("AnimatedSprite2D").play("Idle")
		velocity.x = 0
	
	move_and_slide()


func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase = true


func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase = false


func _on_player_death_body_entered(body):
	if body.name == "Bullet":
		body.queue_free()
		dinoHealth -= 3
		if dinoHealth <= 0:
			death()


func _on_player_collision_body_entered(body):
	if body.name == "Player":
		# body.health -= 3
		Game.playerHP -= 3
		death()
	# print(body.name)
	if body.name == "Bullet":
		body.queue_free()
		dinoHealth -= 3
		if dinoHealth <= 0:
			death()
		
func death():
	# changing velocity would also work
	# velocity.x = 0 # only flipping chase to false is necessary
	Game.gold += 5
	Utils.saveGame()
	chase = false
	get_node("AnimatedSprite2D").play("Death")
	await get_node("AnimatedSprite2D").animation_finished
	self.queue_free()
