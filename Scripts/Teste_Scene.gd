extends Node2D

onready var gate1 = $Gate

func _on_button_button_press():
	print("Butao 1 pressionado")
	$Gate.open(1)

func _on_button2_button_press():
	print("Butao 2 pressionado")
	$Gate.open(0)



