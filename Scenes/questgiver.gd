extends Area2D

@onready var prox = $questProx
@onready var label = $AnimatedSprite2D/DialogLabel

var texty = [
	"Dobrej",
	"Dneska se mi na chatě rozbil solární panel.",
	"Opravoval jsem to pět minut, ale nakonec jsem to nevyřešil.",
	"Kdo mi to opravi, dostane jedničku!"
]
var index = 0
var v_dosahu = false

func _ready():
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	label.position += Vector2(-20, -25)
	label.hide()
	prox.body_entered.connect(func(b): if b.is_in_group("playerTarget"): v_dosahu = true)
	prox.body_exited.connect(func(b):
		if b.is_in_group("playerTarget"):
			v_dosahu = false
			index = 0
			label.hide())

func _input(event):
	if v_dosahu and event.is_action_pressed("interruct"):
		if index < texty.size():
			label.text = texty[index]
			label.size = Vector2(200, 80)
			label.show()
			index += 1
		else:
			label.hide()
			index = 0
