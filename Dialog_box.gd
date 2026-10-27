extends CanvasLayer

signal dialog_finished

var lines: Array[String] = []
var index: int = 0
var active: bool = false

@onready var panel: Panel = $Panel
@onready var speaker_label: Label = $Panel/Speaker
@onready var text_label: Label = $Panel/DialogText


func _ready() -> void:
	panel.visible = false


func start(data: DialogData) -> void:
	if active or data == null or data.lines.is_empty():
		return
	lines = data.lines
	index = 0
	active = true
	speaker_label.text = data.speaker
	text_label.text = lines[0]
	panel.visible = true


func _unhandled_input(event: InputEvent) -> void:
	if active and event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()
		next_line()


func next_line() -> void:
	index += 1
	if index >= lines.size():
		end()
	else:
		text_label.text = lines[index]


func end() -> void:
	if not active:
		return
	active = false
	panel.visible = false
	dialog_finished.emit()
