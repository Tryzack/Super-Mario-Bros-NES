extends StaticBody2D
var abierto = false
@export var item : int = 0
@export var cantidad : int
var scene = load("res://Scenes/moneda_bonus.tscn")

func _ready():
	pass

func romper_cubo():
	if (!abierto):
		
		if(cantidad>0):
			get_node("AnimationPlayer").play("levantar")
		else:
			get_node("AnimationPlayer").play("roto")
			abierto = true
			
		if (item == 0):
			if (cantidad>=1):
				var instance = scene.instantiate()
				add_child(instance)
				instance.animate()
				instance.show()
				cantidad-=1

		elif(item == 1):
			get_node("AnimationPlayer").play("roto")
			abierto = true

func _on_animation_player_animation_finished(anim_name):
	if (anim_name == "roto"):
		queue_free()
