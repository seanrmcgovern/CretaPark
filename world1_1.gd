extends Node2D

@onready var pauseMenu = $PauseCanvasLayer/PauseMenu

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed(Common.Action.PAUSE):
		Utils.togglePauseMenu(pauseMenu)
