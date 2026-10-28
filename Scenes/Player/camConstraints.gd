extends Node

@export var restraint_left :int 
@export var restraint_right :int 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CharacterBody2D/Camera2D.limit_left=restraint_left
	$CharacterBody2D/Camera2D.limit_right=restraint_right


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
