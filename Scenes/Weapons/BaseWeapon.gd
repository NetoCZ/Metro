
extends Node2D
class_name BaseWeapon

@export var weapon_data: WeaponData
@export var swing_angle: float = 120.0
@export var swing_duration: float = 0.25

@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var collision_shape: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var attack_timer: Timer = $AttackTimer
@onready var cooldown_timer: Timer = $CooldownTimer

var can_attack: bool = true
var is_attacking: bool = false
var facing_left: bool = false
var hit_targets: Array[Node2D] = []
var swing_tween: Tween

var damage: int:
	get:
		return weapon_data.damage if weapon_data != null else 0


func _ready() -> void:
	attack_timer.one_shot = true
	cooldown_timer.one_shot = true

	if not attack_timer.timeout.is_connected(_on_attack_timer_timeout):
		attack_timer.timeout.connect(_on_attack_timer_timeout)

	if not cooldown_timer.timeout.is_connected(_on_cooldown_timer_timeout):
		cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)

	if not hitbox.body_entered.is_connected(_on_hitbox_body_entered):
		hitbox.body_entered.connect(_on_hitbox_body_entered)

	hitbox.monitoring = false


func setup(data: WeaponData) -> void:
	if data == null:
		push_error("BaseWeapon: WeaponData не назначен!")
		return

	weapon_data = data

	sprite.texture = weapon_data.weapon_texture
	sprite.scale = weapon_data.weapon_scale

	var rectangle := RectangleShape2D.new()
	rectangle.size = weapon_data.hitbox_size
	collision_shape.shape = rectangle

	attack_timer.wait_time = weapon_data.attack_duration
	cooldown_timer.wait_time = weapon_data.attack_cooldown


func attack() -> void:
	if not can_attack or weapon_data == null:
		return

	can_attack = false
	is_attacking = true
	hit_targets.clear()

	hitbox.set_deferred("monitoring", true)

	attack_timer.start(weapon_data.attack_duration)
	cooldown_timer.start(weapon_data.attack_cooldown)


func _on_attack_timer_timeout() -> void:
	is_attacking = false
	hitbox.set_deferred("monitoring", false)


func _on_cooldown_timer_timeout() -> void:
	can_attack = true


func _on_hitbox_body_entered(body: Node2D) -> void:
	if not is_attacking:
		return

	if body.is_in_group("player"):
		return

	if body in hit_targets:
		return

	if body.has_method("take_damage"):
		hit_targets.append(body)
		body.take_damage(damage)


func set_facing_left(left: bool) -> void:
	facing_left = left
	sprite.flip_h = left


func play_swing() -> void:
	if swing_tween and swing_tween.is_running():
		return

	var direction := -1.0 if facing_left else 1.0
	var start_angle := -swing_angle * direction / 2.0
	var end_angle := swing_angle * direction / 2.0

	rotation_degrees = start_angle

	swing_tween = create_tween()
	swing_tween.tween_property(
		self,
		"rotation_degrees",
		end_angle,
		swing_duration
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	swing_tween.tween_property(
		self,
		"rotation_degrees",
		0.0,
		swing_duration
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
