extends CharacterBody2D
class_name Player

# TODO:
# lower Left/Right Markers when crouching

@onready var playerAnimatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var playerAnimationPlayer: AnimationPlayer = $AnimationPlayer
@onready var playerStateMachine: PlayerStateMachine = $PlayerStateMachine
@onready var groundState: GroundState = $PlayerStateMachine/GroundState
@onready var jumpState: JumpState = $PlayerStateMachine/JumpState
@onready var damagedState: DamagedState = $PlayerStateMachine/DamagedState
@onready var collisionShape: CollisionShape2D = $CollisionShape2D
@onready var crouchRayCast1: RayCast2D = $CrouchRayCast1
@onready var crouchRayCast2: RayCast2D = $CrouchRayCast2
@onready var bulletTimer: Timer = $BulletTimer
@onready var iFramesTimer: Timer = $InvincibilityFramesTimer
@onready var hazardDetectorCollisionShape: CollisionShape2D = $HazardDetector/HazardDetectorCollisionShape2D
@onready var leftMarker: Marker2D = $LeftMarker
@onready var rightMarker: Marker2D = $RightMarker

var standing_hitbox = preload("res://hitboxes/player_standing_hitbox.tres")
var crouching_hitbox = preload("res://hitboxes/player_crouching_hitbox.tres")

const SPEED: float = 130.0
const JUMP_VELOCITY: float = -400.0

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
	if Input.is_action_pressed(Common.Action.SHOOT):
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
	
func processDamage() -> void:
	# start invincibility frames timer
	iFramesTimer.start()
	# transition to damaged state
	playerStateMachine.currentState.TransitionStates.emit(playerStateMachine.currentState, damagedState)
	hazardDetectorCollisionShape.set_deferred("disabled", true) 
	
func isSpaceAboveFree() -> bool:
	return !(crouchRayCast1.is_colliding() || crouchRayCast2.is_colliding()) 

# bullet logic
const bulletPath = preload('res://bullet.tscn')

func shoot():
	isShooting = true
	# bulletTimer used to limit rate of firing bullets
	if bulletTimer.is_stopped() and Game.ammo > 0:
		bulletTimer.start()
		var bullet = bulletPath.instantiate()
		get_parent().add_child(bullet)
		var playerFlipped: bool = playerAnimatedSprite.flip_h
		bullet.position = leftMarker.global_position if playerFlipped else rightMarker.global_position
		var bulletVelocity = -1 if playerFlipped else 1
		bullet.velocity = Vector2(bulletVelocity, 0)

func _on_hazard_detector_area_entered(area):
	# damage could differ between various hazards
	print_debug("hazard area entered: ", area.name)
	if area.name == Common.Hazard.HAZARDAREA:
		Game.playerHP -= 2
		processDamage()

	Utils.saveGame()

