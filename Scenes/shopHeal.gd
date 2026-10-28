extends CollisionShape2D

@onready var area: Area2D = get_parent()
@export var cena: int

func _process(_delta: float) -> void:
	if not Input.is_action_just_pressed("interruct"):
		return
	if GameState.ram < cena:
		return
	if GameState.current_hp == GameState.max_hp:
		return
	for body in area.get_overlapping_bodies():
		if body.is_in_group("player"):
			if body.has_method("take_damage"):
				GameState.add_ram(-cena)
				body.take_damage(-15)
				if GameState.current_hp > GameState.max_hp:
					GameState.current_hp = GameState.max_hp
			return
