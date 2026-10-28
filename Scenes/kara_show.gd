extends Node2D

@onready var kara = $Kara
@onready var delej = $delej
@export var enemy1: Node
@export var enemy2: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	kara.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(_delta):
	if not is_instance_valid(enemy1) and not is_instance_valid(enemy2):
		kara.show()
		delej.play()
		set_process(false)
