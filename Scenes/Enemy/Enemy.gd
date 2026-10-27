extends CharacterBody2D

@export var speed: float = 40.0
@export var gravity: float = 900.0

var direction: int = 1

@onready var sprite = $Sprite2D
@onready var wall_check: RayCast2D = $WallCheck
@onready var ledge_check: RayCast2D = $LedgeChesudo
@onready var hitbox: Area2D = $Hitbox


func _ready() -> void:
	hitbox.body_entered.connect(_on_hitbox_body_entered)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_on_floor():
		if wall_check.is_colliding() or not ledge_check.is_colliding():
			turn_around()

	velocity.x = direction * speed
	move_and_slide()


func turn_around() -> void:
	direction *= -1
	sprite.flip_h = direction < 0
	wall_check.target_position.x *= -1
	ledge_check.position.x *= -1


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage()
