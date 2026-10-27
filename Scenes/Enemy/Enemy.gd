extends CharacterBody2D

@export var speed: float = 40.0
@export var chase_speed: float = 250.0
@export var detect_range: float = 500.0
@export var patrol_distance: float = 10.0
@export var max_health: int = 30

var direction: int = 1
var start_x: float
var health: int
var is_dead: bool = false


func _ready() -> void:
	start_x = global_position.x
	health = max_health
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING


func take_damage(amount: int) -> void:
	if is_dead:
		return

	health -= amount

	# krátké bliknutí při zásahu
	var s := get_node_or_null("Sprite2D")
	if s:
		var tween := create_tween()
		tween.tween_property(s, "modulate", Color(1, 0.3, 0.3), 0.05)
		tween.tween_property(s, "modulate", Color.WHITE, 0.1)

	if health <= 0:
		die()


func die() -> void:
	is_dead = true
	set_physics_process(false)
	for child in get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", true)
	queue_free()


func _physics_process(_delta: float) -> void:
	if is_dead:
		return

	var player = get_tree().get_first_node_in_group("playerTarget")

	if player is Node2D:
		var dist_x = player.global_position.x - global_position.x
		if abs(dist_x) < detect_range:
			if abs(dist_x) > 2.0:
				direction = int(sign(dist_x))
			velocity.x = direction * chase_speed
			velocity.y = 0
			var s = get_node_or_null("Sprite2D")
			if s:
				s.flip_h = direction < 0
			move_and_slide()
			return

	# hlídkování
	if global_position.x > start_x + patrol_distance:
		direction = -1
	elif global_position.x < start_x - patrol_distance:
		direction = 1
	velocity.x = direction * speed
	velocity.y = 0

	var sprite = get_node_or_null("Sprite2D")
	if sprite:
		sprite.flip_h = direction < 0

	move_and_slide()
