extends State

class_name CrouchState
# CrouchState shares some logic with GroundState
# maybe we could make a parent class they both inherit from
# could be overkill though

const CROUCHSPEED: float = 50.0
const JUMP_VELOCITY: float = -400.0

@export var jumpState: JumpState
@export var groundState: GroundState
@export var crouchState: CrouchState

var crouchAnimationInProgress: bool = false

func enter():
	if !previousState is LandingState:
		animationPlayer.play("Crouch")
		crouchAnimationInProgress = true
	player.collisionShape.shape = player.crouching_hitbox
	player.collisionShape.position.y = 3

func exit():
	player.collisionShape.shape = player.standing_hitbox
	player.collisionShape.position.y = 0

func stateInput(event: InputEvent):
	if event.is_action_pressed("jump") && player.isSpaceAboveFree():
		player.jump()

func stateProcess(delta):
	# check if down pressed
	if !player.is_on_floor():
		nextState = jumpState
	elif !Input.is_action_pressed("down") && player.isSpaceAboveFree():
		nextState = groundState
	elif !crouchAnimationInProgress:
		if player.direction && canMove:
			player.velocity.x = player.direction * CROUCHSPEED
			animationPlayer.play("CrouchWalk")
		else:
			player.velocity.x = move_toward(player.velocity.x, 0, CROUCHSPEED)
			if player.isShooting:
				# keep this block for now even though both cases
				# use the same animation
				# may add a firing animation
				animationPlayer.play("CrouchIdle")
			else:
				animationPlayer.play("CrouchIdle")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Crouch":
		crouchAnimationInProgress = false
