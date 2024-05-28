extends MarginContainer
class_name TextBox

signal FinishedDisplaying

@onready var letterDisplayTimer: Timer = $LetterDisplayTimer
@onready var label: Label = $MarginContainer/Label

# could try making this an export variable 
const MAX_WIDTH: int = 256

var text: String = ""
var letterIndex = 0

var letterTime: float = 0.03
var spaceTime: float = 0.06
var punctuationTime: float = 0.2

func displayText(textToDisplay: String):
	text = textToDisplay
	label.text = textToDisplay
	# await text box resized signal, 
	# as it is being adjusted according to the size of our label
	await resized
	# may want to hard code this size for the communicator screen
	custom_minimum_size = min(size.x, MAX_WIDTH)
	# if current x size is greater than MAXWIDTH
	# then we want the label's text to go into a new line 
	if size.x > MAX_WIDTH:
		# forces labels text to go onto new line
		# and forces text box to resize 
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized # wait for x to resize
		await resized # wait for y to resize
		custom_minimum_size.y = size.y

	global_position.x -= size.x / 2
	global_position.y -= size.y + 24
	label.text = ""
	displayLetter()
	
func displayLetter():
	label.text += text[letterIndex]
	letterIndex += 1
	if letterIndex >= text.length():
		FinishedDisplaying.emit()
		return
	
	match text[letterIndex]:
		"!", ".", ",", "?":
			letterDisplayTimer.start(punctuationTime)
		" ":
			letterDisplayTimer.start(spaceTime)
		_:
			letterDisplayTimer.start(letterTime)



func _on_letter_display_timer_timeout():
	displayLetter()
