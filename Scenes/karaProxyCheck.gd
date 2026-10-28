extends Area2D

@onready var popup = $Popus

func _ready():
	popup.hide()
	body_entered.connect(func(body): if body.is_in_group("player"): popup.show())
	body_exited.connect(func(body): if body.is_in_group("player"): popup.hide())
	
