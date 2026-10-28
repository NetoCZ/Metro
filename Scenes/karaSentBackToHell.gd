extends Area2D

@export_file("*.tscn") var next_scene: String
@onready var bell = $Bell
@onready var popup = $"../Popus"
@onready var effect = $"../../../Player/Pent"
@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	effect.hide()

func _process(_delta):
	if Input.is_key_pressed(KEY_E) and popup.visible:
		set_process(false)
		bell.play()
		effect.global_position = player.global_position + Vector2(0, -67)
		effect.show()
		await get_tree().create_timer(3).timeout
		for body in get_overlapping_bodies():
			if body.is_in_group("player"):
				get_tree().change_scene_to_file(next_scene)
				
