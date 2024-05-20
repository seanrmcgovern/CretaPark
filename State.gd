extends Node

class_name State

# currently only manually set to false for LandingState in the inspector
@export var canMove: bool = true

var player: Player
var animationPlayer: AnimationPlayer

var nextState: State
var previousState: State

func stateProcess(delta):
	pass

func stateInput(event: InputEvent):
	pass

func enter():
	pass

func exit():
	pass
