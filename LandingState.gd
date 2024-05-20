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
		nextState = jumpState
	elif Input.is_action_pressed("down"):
		nextState = crouchState
	elif (player.direction):
		nextState = groundState
		
func stateInput(event: InputEvent):
	if event.is_action_pressed("jump") && player.isSpaceAboveFree():
		player.jump()

# listen to signal for end of landing animation to queue groundState
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Land":
		nextState = groundState
