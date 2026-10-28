extends Area2D

@export var heal_amount: int = 5
@onready var jogurt = $jogurt


func _ready():
	body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	if body.is_in_group("playerTarget") and body.has_method("heal"):
		body.heal(heal_amount)
		jogurt.play()
		$Sprite2D.hide()
		$CollisionShape2D.set_deferred("disabled", true)
		await jogurt.finished
		queue_free()
