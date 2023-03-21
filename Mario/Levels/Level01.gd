extends Node2D
signal win
signal muerte
var proyectil_cooldown : bool = true
var proyectil_fuego = load("res://Scenes/fuego_proyectil.tscn")
@onready var mario = get_node("Mario")
var is_in_cave: bool = false
var id_tubo : int
var tipo_tubo : int
var mario_en_tubo : bool = false
var x
var mario_is_on_tp : bool = false

func _ready():
	get_node("sonidos/musica").play()
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
		get_node("cd_proyectil").start()
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
	else:
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
func _on_win():
	mario.warp_to(3192, 184)

func _on_area_2d_body_entered(body):
	if(body.is_in_group("mario")):
		mario.muerte_mario()
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
					x = get_node("Tubo").current_spawn_org_p
				else:
					x = get_node("Tubo").current_spawn_org_g
			2:
				x = mario.global.position
			3:
				if(mario.forma == 0):
					x = get_node("Tubo3").current_spawn_org_p
				else:
					x = get_node("Tubo3").current_spawn_org_g
			4:
				if(mario.forma == 0):
					x = get_node("Tubo4").current_spawn_org_p
				else:
					x = get_node("Tubo4").current_spawn_org_g
		mario.warp_to(x)

func warp_mario():
	match(id_tubo):
		1:
			if(mario.forma == 0):
				x = get_node("Tubo2").current_spawn_org_p
			else:
				x = get_node("Tubo2").current_spawn_org_g
			tipo_tubo = 1
			is_in_cave = true
		2:
			pass
		3:
			if(mario.forma == 0):
				x = get_node("Tubo4").current_spawn_org_p
			else:
				x = get_node("Tubo4").current_spawn_org_g
			tipo_tubo = 0
			is_in_cave = false
		4:
			if(mario.forma == 0):
				x = get_node("Tubo3").current_spawn_org_p
			else:
				x = get_node("Tubo3").current_spawn_org_g
			tipo_tubo = 3
			is_in_cave = true
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
	get_node("flag_touched").start()
	get_node("sonidos/flagpole").play()
	get_node("sonidos/musica").stop()

func _on_bottom_touched_timeout():
	get_node("sonidos/win").play()
	var pos1 = get_node("win_area").global_position
	var pos2 = pos1 + Vector2(16, 156)
	mario.use_sound = false
	mario.warp_to(pos2)
	get_node("Mario/AnimationPlayer").play("gotocastle")
	get_node("next_level").start()

func _on_flag_touched_timeout():
	mario.win = true
	mario.velocity.x = 0
	mario.velocity.y = 50
	get_node("bottom_touched").start()

func _on_next_level_timeout():
	get_tree().change_scene_to_file("res://Levels/Level02.tscn")

func adjust_camera():
	if(not is_in_cave):
		get_node("Mario/Camera2D").limit_left = 0
		get_node("Mario/Camera2D").limit_top = 1
		get_node("Mario/Camera2D").limit_right = 3392
		get_node("Mario/Camera2D").limit_bottom = 224
	if(is_in_cave):
		get_node("Mario/Camera2D").limit_left = 3481
		get_node("Mario/Camera2D").limit_top = 1
		get_node("Mario/Camera2D").limit_right = 3867
		get_node("Mario/Camera2D").limit_bottom = 224

func update_ui():
	get_node("UI/puntuacion/Label2").text = str(Gamehandler.puntuacion)
	get_node("UI/monedas/Label").text = str(Gamehandler.monedas)
	get_node("UI/vidas/Label").text = str(Gamehandler.vidas)


func _on_mario_parar_musica():
	get_node("sonidos/musica").stop()

func _on_time_stop_timeout():
	mario.enabled_movement = true

func _on_mario_cambiar_forma():
	mario.enabled_movement = false
	for i in get_node("objetos/Enemigos").get_children():
		i.enabled_movement = false
	$time_stop.start()
