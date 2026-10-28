extends Area2D

@export var weapon_data: WeaponData

@onready var moop: Sprite2D = $Sprite2D

func _ready() -> void:
	if GameState.moop_picked:
		moop.hide()


func _process(_delta: float) -> void:
	if GameState.moop_picked:
		moop.hide()
		return

	if not Input.is_action_just_pressed("interruct"):
		return

	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			if body.has_method("equip_weapon"):
				body.equip_weapon(weapon_data)
				GameState.moop_picked = true
				moop.hide()
			return
