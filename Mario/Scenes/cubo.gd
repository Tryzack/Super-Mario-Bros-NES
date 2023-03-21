extends StaticBody2D
var abierto : bool = false
@export var item : int #	0 = moneda / 1 = hongo_rojo / 2 = hongo_verde
@export var cantidad : int #cantidad de itmes que tendra (default = 1)
@export var is_visible : bool = true
var moneda = load("res://Scenes/moneda_bonus.tscn") #instancia de monedas
var hongo = load("res://Scenes/hongo.tscn") #instancia de hongos
var flor = load("res://Scenes/flor.tscn") #instancia de flor

func _ready():
	if(not is_visible):
		visible = false
	get_node("AnimationPlayer").play("cubo") #animacion de cubo
	
func romper_cubo():
	if (visible == false):
		visible = true
	if(abierto):
		get_node("sonidos/chocar").play()
	if (not abierto): #si el cubo esta cerrado
		if(cantidad>0): #mientras hallan items dentro del cubo
			get_node("AnimationPlayer").play("levantar") #levantar
			
		if (item == 0 and cantidad > 0):	#Item = 0: moneda
			get_node("sonidos/moneda").play()
			var instance = moneda.instantiate() #crear moneda
			instance.show_behind_parent = true
			add_child(instance)
			cantidad-=1 #restar uno a la cantidad restante
			Gamehandler.agregar_monedas(1)
			Gamehandler.update_ui()

		if (item == 1 and cantidad >=1):	#Item = 1: hongo_rojo
			get_node("sonidos/item").play()
			var instance = hongo.instantiate() #crear hongo
			instance.show_behind_parent = true
			add_child(instance)
			cantidad-=1 #restar uno a la cantidad restante
			
		if (item == 2):
			get_node("sonidos/item").play()
			var instance = hongo.instantiate() #Item = 3: hongo_verde
			instance.tipo = 1 #crear hongo
			instance.show_behind_parent = true
			add_child(instance)
			cantidad -= 1 #restar uno a la cantidad restante
			
		if(item == 3):
			get_node("sonidos/item").play()
			var instance = flor.instantiate()
			instance.tipo = 2
			instance.show_behind_parent = true
			add_child(instance)
			cantidad -= 1

func _on_animation_player_animation_finished(_anim_name):
	if (cantidad == 0): #si no quedan items
		get_node("AnimationPlayer").play("abierto") #dejar sprite abierto
		abierto = true #cambiar estado de abierto
	else: #si quedan items
		get_node("AnimationPlayer").play("cubo") #realizar animacion por defecto
