extends State
class_name JumpState

const SPEED: float = 130.0

@export var landingState: LandingState
@export var crouchState: CrouchState

# add custom enter function with isDamaged parameter 
# to determine hit flash, iframes, and animation
# OR make new DamagedState

func stateProcess(delta):
	if (player.is_on_floor()):
		nextState = crouchState if Input.is_action_pressed("down") else landingState
	
	if player.direction && canMove:
		player.velocity.x = player.direction * SPEED
		
	if player.velocity.y > 0 && player.velocity.x != 0:
		animationPlayer.play("Fall")
