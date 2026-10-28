extends Node

signal ram_changed(amount: int)
signal hp_changed(current_hp: int, max_hp: int)

var flags: Dictionary = {}
var saved_weapon: WeaponData = null
var moop_picked: bool = false
var nene_picked: bool = false
var rj45_picked: bool = false

var ram: int = 0
var current_hp: int = -1   # -1 = ještě nenastaveno
var max_hp: int = 50
var is_rapos: bool = false


func set_flag(flag_name: String) -> void:
	flags[flag_name] = true


func has_flag(flag_name: String) -> bool:
	return flags.get(flag_name, false)


func add_ram(amount: int) -> void:
	ram += amount
	ram_changed.emit(ram)


func spend_ram(amount: int) -> bool:
	if ram < amount:
		return false
	ram -= amount
	ram_changed.emit(ram)
	return true


func set_hp(current: int, maximum: int) -> void:
	current_hp = current
	max_hp = maximum
	hp_changed.emit(current_hp, max_hp)
