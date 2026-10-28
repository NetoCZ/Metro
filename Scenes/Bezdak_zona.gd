extends Area2D

@onready var bezdak = $bezdak

func _ready():
	body_entered.connect(func(b): if b.is_in_group("playerTarget"): bezdak.play())
	
