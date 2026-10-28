extends Area2D

@onready var zvuk = $Zvuk
@export var jen_jednou: bool = false
var prehrano = false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if not body.is_in_group("playerTarget"):
		return
	if jen_jednou and prehrano:
		return
	prehrano = true
	zvuk.play()
