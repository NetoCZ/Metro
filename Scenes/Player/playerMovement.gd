extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ACCELERATION = 1500.0
const FRICTION = 2500.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	
	var direction := Input.get_axis("move_left", "move_right")

	if direction != 0:
		velocity.x = move_toward(
			velocity.x,
			direction * SPEED,
			ACCELERATION * delta
		)
	else:
		velocity.x = move_toward(
			velocity.x,
			0.0,
			FRICTION * delta
		)
	
	if direction != 0:
		animated_sprite.flip_h = direction < 0

	if not is_on_floor():
		animated_sprite.stop()
	elif direction != 0:
		if animated_sprite.animation != "run":
			animated_sprite.play("run")
	else:
		animated_sprite.play("idle")

	move_and_slide()
