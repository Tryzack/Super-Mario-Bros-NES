extends StaticBody2D
var abierto : bool = false #estado del bloque
@export var item : int = 0 #0 = moneda
@export var cantidad : int #cantidad de objetos que tendra (default = 0)
var scene = load("res://Scenes/moneda_bonus.tscn") #instancia moneda
var bloque_exp = load ("res://Scenes/bloque_explota.tscn") #instancia animacion bloque

func _ready():
	pass

func romper_cubo(): #activar y romper el cubo si no tiene items
	if (!abierto): #si el cubo no esta abierto
		
		if(cantidad>0):
			get_node("AnimationPlayer").play("levantar") #levantar si tiene items
		else:
			var instance = bloque_exp.instantiate()	#crear animacion con fisicas
			get_node("sonidos/romper").play()
			add_child(instance)
			get_node("Timer").start()	#romper si no tiene items
			get_node("Timer2").start()
			get_node("Sprite2D").visible = false	
			abierto = true #cambiar el estado del bloque
			
		if (item == 0):
			if (cantidad > 0):
				get_node("sonidos/moneda").play()
				var instance = scene.instantiate() #crear moneda
				instance.show_behind_parent = true
				add_child(instance)
				cantidad -= 1 #restar 1 a la cantidad de items restantes
				Gamehandler.agregar_monedas(1)
				Gamehandler.update_ui()

func activar_cubo(): #activar cubo
	if (item == 0):
		if(cantidad > 0): #si tiene una cantidad restante
			get_node("sonidos/moneda").play()
			Gamehandler.agregar_monedas(1)
			Gamehandler.update_ui()
			var instance = scene.instantiate() #crear moneda
			instance.show_behind_parent = true
			add_child(instance)
			cantidad -= 1 #restar 1 a la cantidad de items restantes
		else:
			get_node("sonidos/chocar").play()
	get_node("AnimationPlayer").play("levantar") #levantar el cubo

func _on_timer_timeout(): #cuando termine el timer:
	queue_free() #desaparecer bloque


func _on_timer_2_timeout():
	get_node("CollisionShape2D").disabled = true
