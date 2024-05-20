extends Label

@export var stateMachine: PlayerStateMachine

func _process(delta):
	text = stateMachine.currentState.name # + ' previous: ' + stateMachine.currentState.previousState.name
