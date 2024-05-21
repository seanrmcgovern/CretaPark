extends State
class_name LandingState

@export var groundState: State
@export var crouchState: CrouchState
@export var jumpState: JumpState

func enter():
	animationPlayer.play("Land")
	player.velocity.x = 0
	player.collisionShape.shape = player.crouching_hitbox
	player.collisionShape.position.y = 3

func exit():
	player.collisionShape.shape = player.standing_hitbox
	player.collisionShape.position.y = 0

func stateProcess(delta):
	if !player.is_on_floor():
		TransitionStates.emit(self, jumpState)
	elif Input.is_action_pressed("down"):
		TransitionStates.emit(self, crouchState)
	elif (player.direction):
		TransitionStates.emit(self, groundState)
		
func stateInput(event: InputEvent):
	if event.is_action_pressed("jump") && player.isSpaceAboveFree():
		TransitionStates.emit(self, jumpState)

# listen to signal for end of landing animation to queue groundState
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Land":
		TransitionStates.emit(self, groundState)
