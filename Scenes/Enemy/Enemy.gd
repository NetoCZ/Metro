extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var kara = $Kara
@onready var delej = $delej
@onready var hit = $hit
@onready var drop_point: Marker2D = get_node_or_null("DropPoint")
@onready var karaKounter: int = 2


@export var speed: float = 40.0
@export var chase_speed: float = 250.0
@export var detect_range: float = 500.0
@export var patrol_distance: float = 120.0
@export var stop_distance: float = 12.0
@export var max_health: int = 30
@export var hit_duration: float = 0.5



# --- DROP ---
@export var ram_scene: PackedScene
@export var ram_value: int = 1

# --- ÚTOK ---
@export var attack_damage: int = 10
@export var attack_range_x: float = 150.0
@export var attack_cooldown: float = 1.0

var direction: int = 1
var start_x: float
var health: int
var is_dead: bool = false
var is_hit: bool = false
var last_hit_time: int = 0
var can_attack: bool = true


func _ready() -> void:
	start_x = global_position.x
	health = max_health
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	sprite.play("run")
		
func karaShow() -> void:
	if karaKounter == 0:
		print("oba mrtvi")
		kara.show()
		delej.play()


func take_damage(amount: int) -> void:
	if is_dead:
		return

	health -= amount

	if health <= 0:
		die()
		queue_free()
		return
		

	is_hit = true
	sprite.play("hit")
	hit.play()

	var my_hit_time := Time.get_ticks_msec()
	last_hit_time = my_hit_time

	await get_tree().create_timer(hit_duration).timeout

	if not is_instance_valid(self) or is_dead or last_hit_time != my_hit_time:
		return
	is_hit = false
	sprite.play("run")


func die() -> void:
	is_dead = true
	velocity = Vector2.ZERO
	set_physics_process(false)
	sprite.play("dead")
	karaKounter = karaKounter - 1
	for child in get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", true)
	var hitbox := get_node_or_null("Hitbox")
	if hitbox:
		hitbox.set_deferred("monitoring", false)
		hitbox.set_deferred("monitorable", false)
	_drop_ram.call_deferred()


func _drop_ram() -> void:
	karaShow()
	if ram_scene == null:
		return
	var ram := ram_scene.instantiate()
	ram.value = ram_value
	get_parent().add_child(ram)
	if drop_point:
		ram.global_position = drop_point.global_position
	else:
		ram.global_position = global_position


func try_attack(player: Node2D) -> void:
	if not can_attack or is_hit:
		return

	var dx: float = abs(player.global_position.x - global_position.x)

	if dx > attack_range_x:
		return

	if player.has_method("take_damage"):
		can_attack = false
		player.take_damage(attack_damage)

		await get_tree().create_timer(attack_cooldown).timeout
		if is_instance_valid(self):
			can_attack = true


func _physics_process(_delta: float) -> void:
	if is_dead:
		return

	var player = get_tree().get_first_node_in_group("playerTarget")

	if player is Node2D and is_instance_valid(player):
		var dist_x: float = player.global_position.x - global_position.x
		if abs(dist_x) < detect_range:
			if abs(dist_x) > stop_distance:
				direction = int(sign(dist_x))
				velocity.x = direction * chase_speed
			else:
				velocity.x = 0.0
			velocity.y = 0
			sprite.flip_h = direction < 0

			try_attack(player)

			move_and_slide()
			return

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
