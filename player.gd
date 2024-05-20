extends CharacterBody2D
class_name Player

# TODO:
# lower Left/Right Markers when crouching

@onready var playerAnimatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var playerAnimationPlayer: AnimationPlayer = $AnimationPlayer
@onready var playerStateMachine: PlayerStateMachine = $PlayerStateMachine
@onready var groundState: GroundState = $PlayerStateMachine/GroundState
@onready var jumpState: JumpState = $PlayerStateMachine/JumpState
@onready var collisionShape: CollisionShape2D = $CollisionShape2D
@onready var crouchRayCast1: RayCast2D = $CrouchRayCast1
@onready var crouchRayCast2: RayCast2D = $CrouchRayCast2
@onready var iFramesTimer: Timer = $InvincibilityFramesTimer
@onready var hazardDetectorCollisionShape: CollisionShape2D = $HazardDetector/HazardDetectorCollisionShape2D

var standing_hitbox = preload("res://hitboxes/player_standing_hitbox.tres")
var crouching_hitbox = preload("res://hitboxes/player_crouching_hitbox.tres")

const SPEED: float = 130.0
const JUMP_VELOCITY: float = -400.0
const DAMAGE_VELOCITY: float = -200.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction: float = 0
var isShooting: bool = false
var isCrouched: bool = false
var isTouchingHazard: bool = false

func _physics_process(delta):
	# iframes opacity effect
	if !iFramesTimer.is_stopped():
		modulate.a = 0.3 if Engine.get_frames_drawn() % 4 == 0 else 1.0
	if hazardDetectorCollisionShape.disabled && iFramesTimer.is_stopped():
		hazardDetectorCollisionShape.set_deferred("disabled", false)
		modulate.a = 1.0
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# action logic
	if Input.is_action_pressed("shoot"):
		shoot()
	else:
		isShooting = false

	# Get the input direction and handle the movement/deceleration.
	direction = Input.get_axis("left", "right")
	if direction == -1:
		playerAnimatedSprite.flip_h = true
	elif direction == 1:
		playerAnimatedSprite.flip_h = false

	move_and_slide()

# TODO: look into moving this logic, checking if this func is necessary
# TODO: implement variable jump heights based on how long jump button is pressed
func jump() -> void:
	velocity.y = JUMP_VELOCITY
	playerStateMachine.currentState.nextState = jumpState
	playerAnimationPlayer.play("Jump")
	
func processDamage() -> void:
	velocity.y = DAMAGE_VELOCITY
	playerStateMachine.currentState.nextState = jumpState
	playerAnimationPlayer.play("Fall")
	# start invincibility frames timer
	iFramesTimer.start()
	# change this to one variable to account for all hazards?
	hazardDetectorCollisionShape.set_deferred("disabled", true) 
	
func isSpaceAboveFree() -> bool:
	return !(crouchRayCast1.is_colliding() || crouchRayCast2.is_colliding()) 

# bullet logic
const bulletPath = preload('res://bullet.tscn')

func shoot():
	isShooting = true
	var bulletTimer = get_node("BulletTimer")
	# bulletTimer used to limit rate of firing bullets
	if bulletTimer.is_stopped() and Game.ammo > 0:
		bulletTimer.start()
		var bullet = bulletPath.instantiate()
		get_parent().add_child(bullet)
		var playerFlipped: bool = playerAnimatedSprite.flip_h
		bullet.position = get_node("LeftMarker").global_position if playerFlipped else get_node("RightMarker").global_position
		var bulletVelocity = -1 if playerFlipped else 1
		bullet.velocity = Vector2(bulletVelocity, 0)

func _on_hazard_detector_area_entered(area):
	# damage could differ between various hazards
	print_debug("hazard area entered: ", area.name)
	if area.name == "HazardArea":
		Game.playerHP -= 2
		
	processDamage()
	Utils.saveGame()

