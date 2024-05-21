extends State
class_name JumpState

# TODO: 
# implement variable jump heights based on how long jump button is pressed
# make speed/jump values global

const SPEED: float = 130.0
const JUMP_VELOCITY: float = -400.0

@export var landingState: LandingState
@export var crouchState: CrouchState

func enter():
	player.velocity.y = JUMP_VELOCITY
	animationPlayer.play("Jump")

func stateProcess(delta):
	if (player.is_on_floor()):
		TransitionStates.emit(self, crouchState if Input.is_action_pressed("down") else landingState)
	if player.direction && canMove:
		player.velocity.x = player.direction * SPEED
		
	if player.velocity.y > 0 && player.velocity.x != 0:
		animationPlayer.play("Fall")
