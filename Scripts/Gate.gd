extends StaticBody2D

func open(open):
	if (open):
		$CollisionShape2D.set_disabled(true)
		$Sprite.hide()
	else:
		$CollisionShape2D.set_disabled(false)
		$Sprite.show()
