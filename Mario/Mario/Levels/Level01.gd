extends Node2D
signal win
signal muerte
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_mario_muerte():
		emit_signal("muerte")
		reinicio()

func reinicio():
	get_tree().reload_current_scene()

func _on_win():
	emit_signal("win")


func _on_area_2d_body_entered(body):
	if(body.is_in_group("mario")):
		get_node("Mario").muerte_mario()
	else:
		body.queue_free()
