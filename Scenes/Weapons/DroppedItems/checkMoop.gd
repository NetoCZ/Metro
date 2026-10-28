extends Area2D

@onready var popup = $Popup

func _ready() -> void:
	popup.hide()
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	


func _on_body_entered(body: Node2D) -> void:
	if not GameState.moop_picked:
		if body.is_in_group("player"):
			popup.show()


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		popup.hide()


func _process(_delta: float) -> void:
	if not Input.is_action_just_pressed("interruct"):
		return

	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			popup.visible = not popup.hidden
			return
