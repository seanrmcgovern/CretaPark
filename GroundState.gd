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
		animationPlayer.play(Common.SpriteAnimation.STANDUP)
		standUpAnimationInProgress = true
		player.velocity.x = 0
		
func exit():
	standUpAnimationInProgress = false

func stateInput(event: InputEvent):
	if event.is_action_pressed(Common.Action.JUMP) && player.isSpaceAboveFree():
		TransitionStates.emit(self, jumpState)

func stateProcess(delta):
	if !player.is_on_floor():
		TransitionStates.emit(self, jumpState)
	elif Input.is_action_pressed(Common.Action.DOWN):
		TransitionStates.emit(self, crouchState)
	elif !standUpAnimationInProgress:
		if player.direction && canMove:
			player.velocity.x = player.direction * SPEED
			animationPlayer.play(Common.SpriteAnimation.RUN)
		else:
			player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
			if player.isShooting:
				animationPlayer.play(Common.SpriteAnimation.SHOOTFORWARD)
			else:
				animationPlayer.play(Common.SpriteAnimation.IDLE)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == Common.SpriteAnimation.STANDUP:
		standUpAnimationInProgress = false
