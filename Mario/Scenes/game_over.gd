extends Node2D

func _ready():
	get_node("AnimationPlayer").play("gameover")
	get_node("AudioStreamPlayer").play()
	get_node("Timer").start()

func _on_timer_timeout():
	Gamehandler.vidas = 3
	Gamehandler.monedas = 0
	Gamehandler.puntuacion = 0
	get_tree().change_scene_to_file("res://Levels/Level01.tscn")
