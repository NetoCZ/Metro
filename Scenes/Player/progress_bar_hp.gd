extends CanvasLayer

@export var player_path: NodePath

@onready var hp_bar: ProgressBar = $HPBar

var player: Node


func _ready() -> void:
	player = get_node(player_path)

	hp_bar.max_value = player.max_hp
	hp_bar.value = player.current_hp

	player.hp_changed.connect(_on_hp_changed)


func _on_hp_changed(current_hp: int, max_hp: int) -> void:
	hp_bar.max_value = max_hp
	hp_bar.value = current_hp
