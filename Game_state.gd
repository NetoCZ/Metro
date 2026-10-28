extends Node

var flags: Dictionary = {}

var saved_weapon: WeaponData = null
var moop_spawned = false

func set_flag(flag_name: String) -> void:
	flags[flag_name] = true

func has_flag(flag_name: String) -> bool:
	return flags.get(flag_name, false)
