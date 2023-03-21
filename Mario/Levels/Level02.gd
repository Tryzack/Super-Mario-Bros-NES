extends Node2D
signal win
signal muerte
var proyectil_cooldown : bool = true
var proyectil_fuego = load("res://Scenes/fuego_proyectil.tscn")
@onready var mario = get_node("Mario")
var world_state : int = 0 # 0 = arriba / 1 = underground / 2 = pipe underground / 3 = arriba_final
var id_tubo : int
var tipo_tubo : int
var mario_en_tubo : bool = false
var x
var mario_is_on_tp : bool = false

func _ready():
	Gamehandler.current_level = self
	update_ui()
	adjust_camera()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (Input.is_action_just_pressed("tecla_espacio") and proyectil_cooldown and mario.forma == 2 and mario.enabled_movement == true):
		get_node("sonidos/bola de fuego").play()
		var instance = proyectil_fuego.instantiate()
		var posicion_mario =mario.global_position
		var posicion = Vector2(5 * mario.last_direction, 0)
		instance.global_position = posicion + posicion_mario
		instance.direction = mario.last_direction
		add_child(instance)
		get_node("timers/cd_proyectil").start()
		proyectil_cooldown = false
		
	if(mario_en_tubo and (mario.is_pressing_s or mario.is_pressing_w or mario.is_pressing_a or mario.is_pressing_d)):
		fix_mario_position()
		
func _on_mario_muerte():
	Gamehandler.vidas -= 1
	emit_signal("muerte")
	reinicio()

func reinicio():
	if Gamehandler.vidas >= 0:
		get_tree().reload_current_scene()

func _on_win():
	mario.warp_to(3192, 184)

func _on_kill_area_body_entered(body):
	if(body.is_in_group("mario")):
		mario.muerte_mario()
	elif(body.is_in_group("platform")):
		var pos = 262
		body.warp_to(pos)
	else:
		body.queue_free()

func _on_cd_proyectil_timeout():
	proyectil_cooldown = true

func _on_tubo_marioenteredtube(id, tipo):
	id_tubo = id
	tipo_tubo = tipo
	mario_en_tubo = true
	print("cuerpo entro")

func _on_tubo_marioexitedtube():
	mario_en_tubo = false
	print("cuerpo salio")
	
func fix_mario_position():
	var required_key
	if(tipo_tubo == 0):
		required_key = mario.is_pressing_s
	elif(tipo_tubo == 1):
		required_key = mario.is_pressing_w
	elif(tipo_tubo == 2):
		required_key = mario.is_pressing_a
	elif(tipo_tubo == 3):
		required_key = mario.is_pressing_d
		
	if(required_key):
		entrar_tubo()
		mario.enabled_movement = false
		match(id_tubo):
			1:
				if(mario.forma == 0):
					x = get_node("objetos/tubos/Tubo").current_spawn_org_p
				else:
					x = get_node("objetos/tubos/Tubo").current_spawn_org_g
			2:
				x = mario.global.position
			3:
				if(mario.forma == 0):
					x = get_node("objetos/tubos/Tubo3").current_spawn_org_p
				else:
					x = get_node("objetos/tubos/Tubo3").current_spawn_org_g
			4:
				x = mario.global.position
			5:
				if(mario.forma == 0):
					x = get_node("objetos/tubos/Tubo5").current_spawn_org_p
				else:
					x = get_node("objetos/tubos/Tubo5").current_spawn_org_g
			6:
				if(mario.forma == 0):
					x = get_node("objetos/tubos/Tubo6").current_spawn_org_p
				else:
					x = get_node("objetos/tubos/Tubo6").current_spawn_org_g
			7:
				if(mario.forma == 0):
					x = get_node("objetos/tubos/Tubo7").current_spawn_org_p
				else:
					x = get_node("objetos/tubos/Tubo7").current_spawn_org_g
			8:
				if(mario.forma == 0):
					x = get_node("objetos/tubos/Tubo8").current_spawn_org_p
				else:
					x = get_node("objetos/tubos/Tubo8").current_spawn_org_g
		mario.warp_to(x)

func warp_mario():
	match(id_tubo):
		1:
			if(mario.forma == 0):
				x = get_node("objetos/tubos/Tubo2").current_spawn_org_p
			else:
				x = get_node("objetos/tubos/Tubo2").current_spawn_org_g
			tipo_tubo = 1
			world_state = 1
			change_music()
		2:
			pass
		3:
			if(mario.forma == 0):
				x = get_node("objetos/tubos/Tubo4").current_spawn_org_p
			else:
				x = get_node("objetos/tubos/Tubo4").current_spawn_org_g
			tipo_tubo = 1
			world_state = 2
		4:
			pass
		5:
			if(mario.forma == 0):
				x = get_node("objetos/tubos/Tubo6").current_spawn_org_p
			else:
				x = get_node("objetos/tubos/Tubo6").current_spawn_org_g
			tipo_tubo = 0
			world_state = 1
		6:
			if(mario.forma == 0):
				x = get_node("objetos/tubos/Tubo5").current_spawn_org_p
			else:
				x = get_node("objetos/tubos/Tubo5").current_spawn_org_g
			tipo_tubo = 3
			world_state = 2
		7:
			if(mario.forma == 0):
				x = get_node("objetos/tubos/Tubo8").current_spawn_org_p
			else:
				x = get_node("objetos/tubos/Tubo8").current_spawn_org_g
			tipo_tubo = 0
			world_state = 3
			change_music()
		8:
			if(mario.forma == 0):
				x = get_node("objetos/tubos/Tubo7").current_spawn_org_p
			else:
				x = get_node("objetos/tubos/Tubo7").current_spawn_org_g
			tipo_tubo = 3
			world_state = 1
			change_music()

	mario.warp_to(x)
	salir_tubo()
	adjust_camera()

func _on_mario_warp():
	warp_mario()
	
func entrar_tubo():
	if(mario.agachado):
		mario.agachado = false
	if(tipo_tubo == 0):
		get_node("Mario/AnimationPlayer").stop()
		get_node("Mario/AnimationPlayer").play("entrar_tubo_abajo")
	elif(tipo_tubo == 1):
		get_node("Mario/AnimationPlayer").stop()
		get_node("Mario/AnimationPlayer").play("entrar_tubo_arriba")
	elif(tipo_tubo == 2):
		get_node("Mario/AnimationPlayer").stop()
		get_node("Mario/AnimationPlayer").play("entrar_tubo_izquierda")
		get_node("Mario/Sprite2D").flip_h = true
	elif(tipo_tubo == 3):
		get_node("Mario/AnimationPlayer").stop()
		get_node("Mario/AnimationPlayer").play("entrar_tubo_derecha")
		

func salir_tubo():
	if(tipo_tubo == 0):
		get_node("Mario/AnimationPlayer").stop()
		get_node("Mario/AnimationPlayer").play("salir_tubo_abajo")
	elif(tipo_tubo == 1):
		get_node("Mario/AnimationPlayer").stop()
		get_node("Mario/AnimationPlayer").play("salir_tubo_arriba")
	elif(tipo_tubo == 2):
		get_node("Mario/AnimationPlayer").stop()
		get_node("Mario/AnimationPlayer").play("salir_tubo_izquierda")
	elif(tipo_tubo == 3):
		get_node("Mario/AnimationPlayer").stop()
		get_node("Mario/AnimationPlayer").play("salir_tubo_derecha")
		get_node("Mario/Sprite2D").flip_h = true

func _on_mario_warped():
	mario.enabled_movement = true

func _on_win_area_flag_touched():
	mario.enabled_movement = false
	get_node("Mario/AnimationPlayer").play("win")
	get_node("timers/flag_touched").start()
	get_node("sonidos/flagpole").play()
	get_node("sonidos/musica_underground").stop()
	get_node("sonidos/musica_upperground").stop()

func _on_bottom_touched_timeout():
	get_node("sonidos/win").play()
	var pos1 = get_node("objetos/win_area").global_position
	var pos2 = pos1 + Vector2(16, 156)
	mario.use_sound = false
	mario.warp_to(pos2)
	get_node("Mario/AnimationPlayer").play("gotocastle")
	get_node("timers/next_level").start()

func _on_flag_touched_timeout():
	mario.win = true
	mario.velocity.x = 0
	mario.velocity.y = 50
	get_node("timers/bottom_touched").start()

func _on_next_level_timeout():
	get_tree().change_scene_to_file("res://Levels/Level01.tscn")

func adjust_camera():
	if(world_state == 0):
		get_node("Mario/Camera2D").limit_left = -96
		get_node("Mario/Camera2D").limit_top = 17
		get_node("Mario/Camera2D").limit_right = 304
		get_node("Mario/Camera2D").limit_bottom = 240
	if(world_state == 1):
		get_node("Mario/Camera2D").limit_left = 0
		get_node("Mario/Camera2D").limit_top = 272
		get_node("Mario/Camera2D").limit_right = 3072
		get_node("Mario/Camera2D").limit_bottom = 480
	if(world_state == 2):
		get_node("Mario/Camera2D").limit_left = 1536
		get_node("Mario/Camera2D").limit_top = 512
		get_node("Mario/Camera2D").limit_right = 1792
		get_node("Mario/Camera2D").limit_bottom = 720
	if(world_state == 3):
		get_node("Mario/Camera2D").limit_left = 2528
		get_node("Mario/Camera2D").limit_top = 17
		get_node("Mario/Camera2D").limit_right = 3072
		get_node("Mario/Camera2D").limit_bottom = 240

func update_ui():
	get_node("UI/puntuacion/Label2").text = str(Gamehandler.puntuacion)
	get_node("UI/monedas/Label").text = str(Gamehandler.monedas)
	get_node("UI/vidas/Label").text = str(Gamehandler.vidas)


func _on_mario_parar_musica():
	get_node("sonidos/musica_upperground").stop()
	get_node("sonidos/musica_underground").stop()

func change_music():
	if(get_node("sonidos/musica_upperground").is_playing()):
		get_node("sonidos/musica_upperground").stop()
		get_node("sonidos/musica_underground").play()
	else:
		get_node("sonidos/musica_underground").stop()
		get_node("sonidos/musica_upperground").play()


func _on_tp_area_body_entered(body):
	if(body.is_in_group("platform")):
		body.warp_to(470)
