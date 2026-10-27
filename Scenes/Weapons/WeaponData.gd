extends Resource
class_name WeaponData

@export var weapon_name: String = "Weapon"
@export var damage: int = 10
@export var attack_cooldown: float = 0.5
@export var attack_duration: float = 0.2
@export var weapon_texture: Texture2D
@export var hitbox_size: Vector2 = Vector2(40, 20)
@export var weapon_scale: Vector2 = Vector2(1.0, 1.0)
