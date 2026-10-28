extends CanvasLayer

@onready var label = $Label

func _ready():
	layer = 100
	GameState.ram_changed.connect(_update)
	_update(GameState.ram)

func _update(v):
	label.text = "RAM: " + str(v)
