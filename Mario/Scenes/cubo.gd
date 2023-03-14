extends StaticBody2D
var abierto = false
@export var item : int #	0 = moneda, 1 = hongo
@export var cantidad : int
var moneda = load("res://Scenes/moneda_bonus.tscn")
var hongo = load("res://Scenes/hongo.tscn")

func _ready():
	get_node("AnimationPlayer").play("cubo")
	
func romper_cubo():
	if (!abierto):
		if(cantidad>0):
			get_node("AnimationPlayer").play("levantar")
			
		if (item == 0 and cantidad >=1):	#Item = 0: moneda
			var instance = moneda.instantiate()
			add_child(instance)
			instance.animate()
			cantidad-=1

		if (item == 1 and cantidad >=1):	#Item = 1: hongo
			var instance = hongo.instantiate()
			add_child(instance)	
			cantidad-=1

func _on_animation_player_animation_finished(_anim_name):
	if (cantidad < 1):
		get_node("AnimationPlayer").play("abierto")
		abierto = true
	else:
		get_node("AnimationPlayer").play("cubo")
