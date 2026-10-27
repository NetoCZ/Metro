extends Node2D
class_name BaseWeapon

@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: Area2D = $Hitbox

var weapon_data: WeaponData
var can_attack := true


func setup(data: WeaponData) -> void:
	weapon_data = data

	if is_node_ready():
		update_weapon()


func _ready() -> void:
	hitbox.monitoring = false
	hitbox.body_entered.connect(_on_body_entered)

	update_weapon()


func update_weapon() -> void:
	if weapon_data == null:
		return

	sprite.texture = weapon_data.weapon_texture


func attack() -> void:
	if not can_attack or weapon_data == null:
		return

	can_attack = false
	hitbox.monitoring = true

	await get_tree().create_timer(0.15).timeout

	hitbox.monitoring = false

	await get_tree().create_timer(
		weapon_data.attack_cooldown
	).timeout

	can_attack = true


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(weapon_data.damage)
