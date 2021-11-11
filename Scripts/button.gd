extends Area2D

signal button_press

onready var sprite = $Sprite

func _ready():
	set_process(false)
	$Label.hide()

func _process(_delta):
	if (Input.is_action_just_pressed("e")):
		button_pressed()

func button_pressed():
	emit_signal("button_press")
	print("Pressionado")
	if sprite.get_frame() == 0:
		sprite.set_frame(1)
	else:
		sprite.set_frame(0)

func _on_button_body_entered(body):
	if body.is_in_group("player"):
		$Label.show()
		set_process(true)


func _on_button_body_exited(body):
	if body.is_in_group("player"):
		$Label.hide()
		set_process(false)
