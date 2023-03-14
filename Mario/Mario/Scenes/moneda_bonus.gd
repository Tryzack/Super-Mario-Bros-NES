extends Sprite2D

func animate(): #animar moneda
	get_node("AnimationPlayer").play("idle")

func _on_animation_player_animation_finished(_anim_name):
	queue_free() #eliminar moneda
