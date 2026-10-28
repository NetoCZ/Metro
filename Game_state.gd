extends Node

var flags: Dictionary = {}

var saved_weapon: WeaponData = null
var moop_picked: bool = false

func set_flag(flag_name: String) -> void:
	flags[flag_name] = true

func has_flag(flag_name: String) -> bool:
	return flags.get(flag_name, false)

signal ram_changed(amount: int)

var ram: int = 0

func add_ram(amount: int) -> void:
	ram += amount
	ram_changed.emit(ram)

signal hp_changed(current_hp: int, max_hp: int)

var current_hp: int = -1 
var max_hp: int = 50


func set_hp(current: int, maximum: int) -> void:
	current_hp = current
	max_hp = maximum
	hp_changed.emit(current_hp, max_hp)
