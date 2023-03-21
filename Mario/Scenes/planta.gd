extends CharacterBody2D

var estado = 0 #0 = afuera / 1 = adentro
var vivo = true

func _ready():
	get_node("idle_animation").play("idle")
	get_node("Timer").start()

func _on_timer_timeout():
	if(estado == 0):
		get_node("AnimationPlayer").play("Entrar al tubo")
		estado = 1
	else:
		get_node("AnimationPlayer").play("Salir del tubo")
		estado = 0
		
func _on_animation_player_animation_finished(anim_name):
	if(anim_name =="Entrar al tubo" or anim_name == "Salir del tubo"):
		get_node("Timer").start()

func muerte():
	get_node("dead").play()
	Gamehandler.agregar_puntuacion(200)
	queue_free()
