extends Node

var dialogLines: Array[String] = []
var currentLineIndex: int = 0

var textBox
var textBoxPosition: Vector2

var sfx: AudioStream

var isDialogActive: bool = false
var canAdvanceLine: bool = false

@onready var textBoxScene = preload("res://textBox.tscn")

func startDialog(position: Vector2, lines: Array[String], speechSfx: AudioStream):
	# a dialog is already active, then we don't want to start another one
	if isDialogActive:
		return
	dialogLines = lines
	textBoxPosition = position
	textBoxPosition.y -= 15
	sfx = speechSfx
	showTextBox()
	isDialogActive = true
	
func showTextBox():
	textBox = textBoxScene.instantiate()
	textBox.FinishedDisplaying.connect(onTextBoxFinishedDisplaying)
	get_tree().root.add_child(textBox)
	textBox.global_position = textBoxPosition
	textBox.displayText(dialogLines[currentLineIndex], sfx)
	canAdvanceLine = false
	
func onTextBoxFinishedDisplaying():
	canAdvanceLine = true
	
func _unhandled_input(event):
	if (event.is_action_pressed("advanceDialog") && isDialogActive && canAdvanceLine):
		textBox.queue_free()
		currentLineIndex += 1
		if currentLineIndex >= dialogLines.size():
			isDialogActive = false
			currentLineIndex = 0
			Game.playerStateMachine.exitPausedState()
			return
		showTextBox()
