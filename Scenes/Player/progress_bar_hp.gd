extends CanvasLayer

@export var player_path: NodePath

@onready var hp_bar: ProgressBar = $HPBar

var player: CharacterBody2D


func _ready() -> void:
	player = get_node_or_null(player_path) as CharacterBody2D

	if player == null:
		return

	player.hp_changed.connect(_on_hp_changed)

	hp_bar.max_value = player.max_hp
	hp_bar.value = player.current_hp

	print("HP UI подключён. Текущее HP: ", player.current_hp)


func _on_hp_changed(current_hp: int, max_hp: int) -> void:
	hp_bar.max_value = max_hp
	hp_bar.value = current_hp

	print("HP Bar обновлён: ", current_hp, "/", max_hp)
