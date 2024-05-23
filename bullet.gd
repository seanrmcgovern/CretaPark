extends CharacterBody2D

# TODO:
# Add different guns/bullets, which varying fire rates and effects
# ammo crates, cool metroid style ammo gauge
# add collectibles, dino eggs, amber, etc.
# add animation for shaking head or looking at gun when trying to shoot without ammo

# art todos:
# ammo icons/gauge

# Cool fonts:
# Rubik Mono One
# Share Tech Mono
# Micro 5
# Anta
# Kode Mono

#var bulletVelocity = Vector2(1, 0)
const SPEED = 300.0
var bulletIsExploded = false

@onready var bulletDespawnTimer: Timer = $BulletDespawnTimer
@onready var bulletAnimatedSprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	if Game.ammo > 0:
		Game.ammo -= 1

func _physics_process(delta):
	if not bulletIsExploded:
		# capture collision info by assigning to variable
		var collisionInfo = move_and_collide(velocity.normalized() * delta * SPEED)
	
	if bulletDespawnTimer.is_stopped():
		self.queue_free()

func _on_bullet_collision_body_entered(body):
	if (body.name != Common.Body.BULLET):
		bulletAnimatedSprite.play(Common.SpriteAnimation.EXPLODE)
		bulletIsExploded = true
		await bulletAnimatedSprite.animation_finished
		self.queue_free()

