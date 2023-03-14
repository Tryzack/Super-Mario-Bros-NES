extends StaticBody2D
var abierto : bool = false #estado del bloque
@export var item : int = 0 #0 = moneda
@export var cantidad : int #cantidad de objetos que tendra (default = 0)
var scene = load("res://Scenes/moneda_bonus.tscn") #instancia moneda

func _ready():
	pass

func romper_cubo(): #activar y romper el cubo si no tiene items
	if (!abierto): #si el cubo no esta abierto
		
		if(cantidad>0):
			get_node("AnimationPlayer").play("levantar") #levantar si tiene items
		else:
			get_node("AnimationPlayer").play("roto")	#romper si no tiene items
			abierto = true
			
		if (item == 0):
			if (cantidad > 0):
				var instance = scene.instantiate() #crear moneda
				add_child(instance)
				instance.animate() #animar moneda 
				cantidad -= 1 #restar 1 a la cantidad de items restantes

func activar_cubo(): #activar cubo
	if (item == 0):
		if(cantidad > 0): #si tiene una cantidad restante
			var instance = scene.instantiate() #crear moneda
			add_child(instance)
			instance.animate() #animar moneda
			cantidad -= 1 #restar 1 a la cantidad de items restantes
	get_node("AnimationPlayer").play("levantar") #levantar el cubo

func _on_animation_player_animation_finished(anim_name):
	if (anim_name == "roto"): #cuando termine la animacion del bloque roto:
		queue_free() #desaparecer bloque
