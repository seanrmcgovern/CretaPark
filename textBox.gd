extends MarginContainer

signal FinishedDisplaying

@onready var letterDisplayTimer: Timer = $LetterDisplayTimer
@onready var label: Label = $MarginContainer/Label

const MAX_WIDTH: int = 150
const MAX_HEIGHT: int = 20

var text: String = ""
var letterIndex = 0

var letterTime: float = 0.05
var spaceTime: float = 0.08
var punctuationTime: float = 0.2

func displayText(textToDisplay: String):
	text = textToDisplay
	label.text = textToDisplay
	# await text box resized signal, 
	# as it is being adjusted according to the size of our label
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	# if current x size is greater than MAXWIDTH
	# then we want the label's text to go into a new line 
	if size.x > MAX_WIDTH:
		# forces labels text to go onto new line
		# and forces text box to resize 
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized # wait for x to resize
		await resized # wait for y to resize
		print_debug("sizeY: ", size.y)
		#custom_minimum_size.y = size.y
		custom_minimum_size.y = min(size.y, MAX_HEIGHT)

	global_position.x -= (size.x / 2) * scale.x
	global_position.y -= (size.y + 24) * scale.y
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
