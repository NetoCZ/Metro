extends CanvasLayer

@onready var label = $Label
@onready var hp_label = $HPLabel


func _ready():
	layer = 100
	GameState.ram_changed.connect(_update_ram)
	GameState.hp_changed.connect(_update_hp)
	_update_ram(GameState.ram)
	_update_hp(maxi(GameState.current_hp, 0), GameState.max_hp)


func _update_ram(v):
	label.text = str(v)


func _update_hp(current, maximum):
	hp_label.text = str(current) + " / " + str(maximum)
