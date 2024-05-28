extends Node
class_name PlayerStateMachine

@export var player: Player
@export var animationPlayer: AnimationPlayer
@export var currentState: State
var states: Array[State]

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is State:
			states.append(child)
			child.player = player
			child.animationPlayer = animationPlayer
			# connect the transition signal
			child.TransitionStates.connect(transitionStates)
		else:
			push_warning("Child: " + child.name + " is not a valid state for the PlayerStateMachine")

func _physics_process(delta):
	currentState.stateProcess(delta)
	
func transitionStates(curState: State, newState: State):
	var previousState: State
	# return if the current state does not match the passed curState
	if currentState != curState:
		return
	# handle current state
	if (currentState != null):
		currentState.exit()
		previousState = currentState
	# update current state with newState
	currentState = newState
	currentState.previousState = previousState
	currentState.enter()
	
func _input(event: InputEvent):
	currentState.stateInput(event);

func canPlayerMove():
	return currentState.canMove
