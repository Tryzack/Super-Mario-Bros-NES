extends StaticBody2D
var abierto : bool = false
@export var item : int #	0 = moneda, 1 = hongo
@export var cantidad : int #cantidad de itmes que tendra (default = 1)
var moneda = load("res://Scenes/moneda_bonus.tscn") #instancia de monedas
var hongo = load("res://Scenes/hongo.tscn") #instancia de hongos

func _ready():
	get_node("AnimationPlayer").play("cubo") #animacion de cubo
	
func romper_cubo():
	if (!abierto): #si el cubo esta cerrado
		if(cantidad>0): #mientras hallan items dentro del cubo
			get_node("AnimationPlayer").play("levantar") #levantar
			
		if (item == 0 and cantidad > 0):	#Item = 0: moneda
			var instance = moneda.instantiate() #crear moneda
			add_child(instance)
			instance.animate() #animar moneda
			cantidad-=1 #restar uno a la cantidad restante

		if (item == 1 and cantidad >=1):	#Item = 1: hongo
			var instance = hongo.instantiate() #crear hongo
			add_child(instance)	
			cantidad-=1 #restar uno a la cantidad restante

func _on_animation_player_animation_finished(_anim_name):
	if (cantidad == 0): #si no quedan items
		get_node("AnimationPlayer").play("abierto") #dejar sprite abierto
		abierto = true #cambiar estado de abierto
	else: #si quedan items
		get_node("AnimationPlayer").play("cubo") #realizar animacion por defecto
