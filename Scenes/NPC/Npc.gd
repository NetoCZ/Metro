extends Node2D

@export var dialog: DialogData

var player_near: bool = false

@onready var hint: Label = $Hint
@onready var zone: Area2D = $InteractZone


func _ready() -> void:
	hint.visible = false
	zone.body_entered.connect(_on_body_entered)
	zone.body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_near = true
		hint.visible = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_near = false
		hint.visible = false
		DialogManager.end()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_near and not DialogManager.active:
		get_viewport().set_input_as_handled()
		DialogManager.start(dialog)
