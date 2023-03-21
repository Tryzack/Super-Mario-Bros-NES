extends Area2D
@export var tipo : int # 0 = abajo /  1 = arriba / 2 = izquierda / 3 = derecha
@export var id : int
var current_spawn_org_p
var current_spawn_org_g
var current_spawn_dest_g
var current_spawn_dest_p
signal marioenteredtube(id, tipo)
signal marioexitedtube

var ism : bool = false #"is mario here" o, esta mario aqui

func _ready():
	
	match(tipo):
		0:
			current_spawn_org_p = get_node("TP_mario_p_arriba").global_position
			current_spawn_org_g = get_node("TP_mario_g_arriba").global_position
		1:
			current_spawn_org_p = get_node("TP_mario_p_arriba").global_position
			current_spawn_org_g = get_node("TP_mario_g_arriba").global_position
		2:
			current_spawn_org_p = get_node("TP_mario_derecha").global_position
			current_spawn_org_g = get_node("TP_mario_derecha").global_position
		3:
			current_spawn_org_p = get_node("TP_mario_izquierda").global_position
			current_spawn_org_g = get_node("TP_mario_izquierda").global_position
		_:
			print("error tuberia")

func _on_body_entered(body):
	if(body.is_in_group("mario")):
		ism = true
		emit_signal("marioenteredtube", id, tipo)

func _on_body_exited(body):
	if(body.is_in_group("mario")):
		emit_signal("marioexitedtube")
