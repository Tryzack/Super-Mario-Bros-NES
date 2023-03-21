extends Node

var vidas : int = 3
var puntuacion : int = 0
var monedas : int = 0
var gravity = 1000
var current_level

func _ready():
	pass 
func _process(_delta):
	pass

func agregar_monedas(x):
	monedas += x
	print(monedas)
	if(monedas % 100 == 0):
		agregar_vidas(1)

func agregar_puntuacion(x):
	puntuacion += x
	print(puntuacion)

func agregar_vidas(x):
	vidas += x
	print(vidas)

func GameOver():
	print("game over")

func update_ui():
	current_level.update_ui()
