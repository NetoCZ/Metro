extends CharacterBody2D

@export var starting_weapon: WeaponData

@onready var weapon_holder: Node2D = $WeaponHolder

var current_weapon: BaseWeapon

func _ready() -> void:
	if starting_weapon != null:
		equip_weapon(starting_weapon)


func equip_weapon(data: WeaponData) -> void:
	if current_weapon != null:
		current_weapon.queue_free()

	var weapon_scene = preload(
        "res://Scenes/Weapons/BaseWeapon.tscn"
	)

	current_weapon = weapon_scene.instantiate() as BaseWeapon

	weapon_holder.add_child(current_weapon)
	current_weapon.setup(data)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		if current_weapon != null:
			current_weapon.attack()
