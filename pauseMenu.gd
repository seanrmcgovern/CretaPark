extends Control

@onready var pauseAudioStreamPlayer: AudioStreamPlayer = $PauseAudioStreamPlayer
@onready var resumeAudioStreamPlayer: AudioStreamPlayer = $ResumeAudioStreamPlayer
@onready var pauseSound = preload("res://Sounds/pause.wav")
@onready var resumeSound = preload("res://Sounds/resume.wav")

func _ready():
	pauseAudioStreamPlayer.stream = pauseSound
	pauseAudioStreamPlayer.volume_db = 3
	resumeAudioStreamPlayer.stream = resumeSound
	resumeAudioStreamPlayer.volume_db = 3

func _on_resume_pressed():
	Utils.togglePauseMenu(self)

func _on_quit_pressed():
	get_tree().quit()
