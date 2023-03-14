extends CollisionShape2D
var cuerpo
signal cuerpoEntro

func _on_area_2d_body_entered(body):
	cuerpo = body
	emit_signal("cuerpoEntro")

func devolverBody():
	return cuerpo
