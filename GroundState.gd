extends State

#TODO: 
# 1) May need to break this out into Idle, Running, etc. states
# 2) Look into using signals instead of using a nextState variable to indicate state transitions 
	# it most likely involves using a custom code defined signal
	# look up GDQuest's online tutorial on state machines for an example using an onTransitioned function
class_name GroundState

const SPEED: float = 130.0
const JUMP_VELOCITY: float = -400.0

@export var jumpState: JumpState
@export var crouchState: CrouchState

var standUpAnimationInProgress: bool = false

func enter():
	if previousState is CrouchState:
		animationPlayer.play("StandUp")
		standUpAnimationInProgress = true
		player.velocity.x = 0
		
func exit():
	standUpAnimationInProgress = false

func stateInput(event: InputEvent):
	if event.is_action_pressed("jump") && player.isSpaceAboveFree():
		player.jump()

func stateProcess(delta):
	if !player.is_on_floor():
		nextState = jumpState
	elif Input.is_action_pressed("down"):
		nextState = crouchState
	elif !standUpAnimationInProgress:
		if player.direction && canMove:
			player.velocity.x = player.direction * SPEED
			animationPlayer.play("Run")
		else:
			player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
			if player.isShooting:
				animationPlayer.play("FaceForwardAndShoot")
			else:
				animationPlayer.play("Idle")


func _on_animation_player_animation_finished(anim_name):
	# TODO: Make enum for animations
	if anim_name == "StandUp":
		standUpAnimationInProgress = false
