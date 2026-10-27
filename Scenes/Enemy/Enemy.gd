extends CharacterBody2D

@export var speed: float = 40.0
@export var chase_speed: float = 250.0
@export var detect_range: float = 500.0
@export var patrol_distance: float = 120.0
@export var stop_distance: float = 12.0
@export var max_health: int = 30
@export var hit_duration: float = 0.5

var direction: int = 1
var start_x: float
var health: int
var is_dead: bool = false
var is_hit: bool = false
var last_hit_time: int = 0

@onready var sprite: AnimatedSprite2D = $Sprite2D


func _ready() -> void:
	start_x = global_position.x
	health = max_health
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	sprite.play("run")


func take_damage(amount: int) -> void:
	if is_dead:
		return

	health -= amount

	if health <= 0:
		die()
		return

	is_hit = true
	sprite.play("hit")

	var my_hit_time := Time.get_ticks_msec()
	last_hit_time = my_hit_time

	await get_tree().create_timer(hit_duration).timeout

	# pokud mezitím přišel další zásah, ten se postará o návrat
	if is_dead or last_hit_time != my_hit_time:
		return
	is_hit = false
	sprite.play("run")


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
		var dist_x: float = player.global_position.x - global_position.x
		if abs(dist_x) < detect_range:
			if abs(dist_x) > stop_distance:
				direction = int(sign(dist_x))
				velocity.x = direction * chase_speed
			else:
				velocity.x = 0.0
			velocity.y = 0
			sprite.flip_h = direction < 0
			move_and_slide()
			return

	# hlídkování
	if global_position.x > start_x + patrol_distance:
		direction = -1
	elif global_position.x < start_x - patrol_distance:
		direction = 1
	elif is_on_wall():
		direction *= -1

	velocity.x = direction * speed
	velocity.y = 0
	sprite.flip_h = direction < 0
	move_and_slide()
