extends CharacterBody2D

@export var speed: float = 40.0
@export var chase_speed: float = 250.0
@export var detect_range: float = 500.0
@export var patrol_distance: float = 10.0

var direction: int = 1
var start_x: float


func _ready() -> void:
	start_x = global_position.x
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING


func _physics_process(_delta: float) -> void:
	var player = get_tree().get_first_node_in_group("playerTarget")

	if player == null:
		print("Hráč není ve skupině 'player'")
	elif player is Node2D:
		var dist_x = player.global_position.x - global_position.x
		if abs(dist_x) < detect_range:
			if abs(dist_x) > 2.0:
				direction = int(sign(dist_x))
			velocity.x = direction * chase_speed
			velocity.y = 0
			var s = get_node_or_null("Sprite2D")
			if s:
				s.flip_h = direction < 0
			move_and_slide()
			return

	# hlídkování
	if global_position.x > start_x + patrol_distance:
		direction = -1
	elif global_position.x < start_x - patrol_distance:
		direction = 1
	velocity.x = direction * speed
	velocity.y = 0

	var sprite = get_node_or_null("Sprite2D")
	if sprite:
		sprite.flip_h = direction < 0

	move_and_slide()
