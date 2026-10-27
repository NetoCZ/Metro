
extends Area2D

@export_file("*.tscn") var next_scene: String

@onready var prompt: Sprite2D = $Area2D/Sprite2D

var player_nearby: bool = false

func _ready() -> void:
	prompt.hide()
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _process(_delta: float) -> void:
	if player_nearby and Input.is_action_just_pressed("interruct"):
		if next_scene != "":
			get_tree().change_scene_to_file(next_scene)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = true
		prompt.show()


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = false
		prompt.hide()
