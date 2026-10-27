extends Area2D

@export_file("*.tscn") var next_scene: String

func _process(_delta):
	if Input.is_key_pressed(KEY_E):
		for body in get_overlapping_bodies():
			if body.is_in_group("player"):
				get_tree().change_scene_to_file(next_scene)
				
