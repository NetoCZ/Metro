extends CanvasLayer

@export var player_path: NodePath

@onready var hp_bar: ProgressBar = $HPBar

@onready var player = get_parent()


func _ready() -> void:
	print("=== DEBUG HP UI ===")
	print("PlayerUI node: ", get_path())
	print("Player path из Inspector: ", player_path)

	var node = get_node_or_null(player_path)

	print("Найденный узел: ", node)

	if node == null:
		print("ОШИБКА: игрок по этому пути не найден!")
		return

	print("Тип узла: ", node.get_class())
	print("Скрипт узла: ", node.get_script())

	if not node.has_signal("hp_changed"):
		print("ОШИБКА: у узла нет сигнала hp_changed!")
		return

	player = node as CharacterBody2D

	if player == null:
		print("ОШИБКА: найденный узел не CharacterBody2D!")
		return

	player.hp_changed.connect(_on_hp_changed)

	hp_bar.max_value = player.max_hp
	hp_bar.value = player.current_hp

	print("УСПЕХ: HP UI подключён!")
	print("HP: ", player.current_hp, "/", player.max_hp)


func _on_hp_changed(current_hp: int, max_hp: int) -> void:
	hp_bar.max_value = max_hp
	hp_bar.value = current_hp

	print("HP Bar обновлён: ", current_hp, "/", max_hp)
