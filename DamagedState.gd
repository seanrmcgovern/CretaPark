extends State
class_name DamagedState

const SPEED: float = 130.0
const DAMAGE_VELOCITY: float = -200.0

@export var landingState: LandingState
@export var crouchState: CrouchState

func enter():
	player.velocity.y = DAMAGE_VELOCITY
	animationPlayer.play(Common.SpriteAnimation.FALL)

func stateProcess(delta):
	if (player.is_on_floor()):
		TransitionStates.emit(self, crouchState if Input.is_action_pressed(Common.Action.DOWN) else landingState)
	if player.direction && canMove:
		player.velocity.x = player.direction * SPEED
