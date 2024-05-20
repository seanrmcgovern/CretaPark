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
		else:
			push_warning("Child: " + child.name + " is not a valid state for the PlayerStateMachine")

func _physics_process(delta):
	if (currentState.nextState != null):
		switchStates(currentState.nextState) 
	currentState.stateProcess(delta)

func switchStates(newState: State):
	var previousState: State
	if (currentState != null):
		currentState.exit()
		currentState.nextState = null
		previousState = currentState
	
	currentState = newState
	currentState.previousState = previousState
	currentState.enter()
	
func _input(event: InputEvent):
	currentState.stateInput(event);

func canPlayerMove():
	return currentState.canMove
