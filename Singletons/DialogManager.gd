extends Node

@onready var textBoxScene = preload("res://textBox.tscn")

var dialogLines: Array[String] = []
var currentLineIndex: int = 0

var textBox
var textBoxPosition: Vector2

var isDialogActive: bool = false
var canAdvanceLine: bool = false

func startDialog(position: Vector2, lines: Array[String]):
	# a dialog is already active, then we don't want to start another one
	if isDialogActive:
		return
	dialogLines = lines
	textBoxPosition = position
	showTextBox()
	isDialogActive = true
	
func showTextBox():
	textBox = textBoxScene.instantiate()
	textBox.FinishedDisplaying.connect(onTextBoxFinishedDisplaying)
	get_tree().root.add_child(textBox)
	textBox.global_position = textBoxPosition
	textBox.displayText(dialogLines[currentLineIndex])
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
			return
			
		showTextBox()
