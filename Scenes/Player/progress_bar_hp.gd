extends CanvasLayer

@export var player_path: NodePath
@onready var hp_bar: ProgressBar = $HPBar

var player: CharacterBody2D


func _ready() -> void:
	player = get_node_or_null(player_path) as CharacterBody2D

	if player == null:
		push_error("Игрок не найден! Проверь Player Path в Inspector.")
		return

	hp_bar.max_value = player.max_hp
	hp_bar.value = player.current_hp

	player.hp_changed.connect(_on_hp_changed)


func _on_hp_changed(current_hp: int, max_hp: int) -> void:
	hp_bar.max_value = max_hp
	hp_bar.value = current_hp
