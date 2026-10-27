extends CharacterBody2D

func _ready() -> void:
	$Label.hide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$Label.show()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		$Label.hide()
