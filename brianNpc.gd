extends CharacterBody2D

@onready var brianAnimatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var speechBubbleSprite: Sprite2D = $SpeechBubbleSprite
@onready var speechSound = preload("res://Sounds/speech.wav")
@onready var interactionArea: Area2D = $InteractionArea

var brianLevel1Lines: Array[String] = [
	"Welcome, to Cretacious Park!",
	"That's Creta Park for short.",
	"You got here just in time!!",
	"We need your help to send this island back in time.",
	"Or else these dinosaurs will be stuck in our era for good.",
	"I am NOT trying to be a dino snack, so..",
	"You'll want to collect the key cards to make your way through the park's various zones",
	"Godspeed!",
]

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

func _on_interaction_area_body_entered(body):
	if body.name == Common.Body.PLAYER:
		speechBubbleSprite.visible = true


func _on_interaction_area_body_exited(body):
	if body.name == Common.Body.PLAYER:
		speechBubbleSprite.visible = false

func _unhandled_input(event):
	if event.is_action_pressed("advanceDialog"):
		if (speechBubbleSprite.visible):
			speechBubbleSprite.visible = false
			DialogManager.startDialog(global_position, brianLevel1Lines, speechSound)
			#brianAnimatedSprite.flip_h = true if interactionArea.get_overlapping_bodies()[0].global_position.x < global_position.x else false
			
