extends MarginContainer

signal FinishedDisplaying

const MAX_WIDTH: int = 150
const MAX_HEIGHT: int = 10

var text: String = ""
var letterIndex = 0
var letterTime: float = 0.05
var spaceTime: float = 0.08
var punctuationTime: float = 0.2

@onready var letterDisplayTimer: Timer = $LetterDisplayTimer
@onready var label: Label = $MarginContainer/Label
@onready var audioPlayer: AudioStreamPlayer = $AudioStreamPlayer
@onready var nextIndicator: AnimatedSprite2D = $NinePatchRect/Control2/NextIndicator

func _ready():
	# start scale at (0, 0) for popup animation
	scale = Vector2.ZERO

func displayText(textToDisplay: String, speechSfx: AudioStream):
	text = textToDisplay
	label.text = textToDisplay
	audioPlayer.stream = speechSfx
	
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
		#custom_minimum_size.y = size.y
		custom_minimum_size.y = min(size.y, MAX_HEIGHT)

	global_position.x -= (size.x / 2)
	global_position.y -= (size.y + 24)
	label.text = ""
	
	# setup popup animation
	pivot_offset = Vector2(size.x/2, size.y)
	var tween = get_tree().create_tween()
	tween.tween_property(
		self, "scale", Vector2(1, 1), 0.2
	).set_trans(Tween.TRANS_BACK)
	
	displayLetter()
	
func displayLetter():
	label.text += text[letterIndex]
	letterIndex += 1
	if letterIndex >= text.length():
		FinishedDisplaying.emit()
		nextIndicator.visible = true
		return
	
	match text[letterIndex]:
		"!", ".", ",", "?":
			letterDisplayTimer.start(punctuationTime)
		" ":
			letterDisplayTimer.start(spaceTime)
		_:
			letterDisplayTimer.start(letterTime)
			# create new audio player by duplicating our current audio player
			var newAudioPlayer: AudioStreamPlayer = audioPlayer.duplicate()
			# randomize pitch scale
			newAudioPlayer.pitch_scale += randf_range(-0.1, 0.1)
			# for more fun variation, inscrease pitch scale if letter is a vowel
			if text[letterIndex] in ["a", "e", "i", "o", "u"]:
				newAudioPlayer.pitch_scale += 0.2
			# add new audio player into the scene
			get_tree().root.add_child(newAudioPlayer)
			# play newAudioPlayer, wait for the sound to finish, and destroy it
			newAudioPlayer.play()
			await newAudioPlayer.finished
			newAudioPlayer.queue_free()

func _on_letter_display_timer_timeout():
	displayLetter()
