extends CharacterBody2D

var player_near := false

func _ready() -> void:
	$Label.text = "Dobrý den"
	$Label.hide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_near = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_near = false
		$Label.hide()

func _unhandled_input(event: InputEvent) -> void:
	if player_near and event.is_action_pressed("interact"):
		$Label.show()
