extends CollisionShape2D
var cuerpo
signal cuerpoEntro
# Called when the node enters the scene tree for the first time.
func _ready():
	desactivar_colisiones()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_2d_body_entered(body): #cuando un cuerpo entra
	cuerpo = body #asignar el cuerpo que entro a una variable
	emit_signal("cuerpoEntro") #emitir senal de que entro un cuerpo

func devolverBody():
	return cuerpo #devolver cuerpo que entro

func desactivar_colisiones(): #desactivar colisiones existentes
	get_node("RayCastCabeza").enabled = false
	get_node("RayCastPisar").enabled = false
	get_node("Area2D/CollisionShape2D").set_deferred("disabled", true)

func activar_colisiones(): #activar colisiones existentes
	get_node("RayCastCabeza").enabled = true
	get_node("RayCastPisar").enabled = true
	get_node("Area2D/CollisionShape2D").set_deferred("disabled", false)
