extends Area2D
signal flag_touched

func _on_body_entered(body):
	if(body.is_in_group("mario")):
		emit_signal("flag_touched")
