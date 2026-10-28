extends Area2D



func _process(_delta):
	if Input.is_key_pressed(KEY_E):
		for body in get_overlapping_bodies():
			if body.is_in_group("player"):
				body.make_rapos()
				queue_free()
