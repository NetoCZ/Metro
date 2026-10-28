extends CollisionShape2D

@export var weapon_data: WeaponData
@export var cena: int

@onready var area: Area2D = get_parent()

func _process(_delta: float) -> void:
	if not Input.is_action_just_pressed("interruct"):
		return
	if GameState.ram < cena:
		return
	for body in area.get_overlapping_bodies():
		if body.is_in_group("player"):
			if body.has_method("equip_weapon"):
				body.equip_weapon(weapon_data)
				GameState.add_ram(-cena)
				GameState.saved_weapon = weapon_data
				GameState.moop_picked = true
			return
