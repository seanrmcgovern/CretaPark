extends State
class_name PausedState

func enter():
	animationPlayer.play(Common.SpriteAnimation.SHOOTFORWARD)

func exit():
	animationPlayer.play(Common.SpriteAnimation.IDLE)
