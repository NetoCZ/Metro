extends Control


func _ready():
	RamHud.hide()


func _input(event):
	if event.is_action_pressed("ui_accept"):
		RamHud.show()
		get_tree().change_scene_to_file("res://Scenes/metro_main.tscn")
