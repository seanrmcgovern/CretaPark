extends State
class_name FallState

const SPEED: float = 130.0

@export var landingState: LandingState
@export var crouchState: CrouchState

func enter():
	animationPlayer.play(Common.SpriteAnimation.FALL)

func stateProcess(delta):
	if (player.is_on_floor()):
		TransitionStates.emit(self, crouchState if Input.is_action_pressed(Common.Action.DOWN) else landingState)
	if player.direction && canMove:
		player.velocity.x = player.direction * SPEED
