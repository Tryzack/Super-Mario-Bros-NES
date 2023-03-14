extends CollisionShape2D
var cuerpo
signal cuerpoEntro
# Called when the node enters the scene tree for the first time.
func _ready():
	desactivar_colisiones()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	cuerpo = body
	emit_signal("cuerpoEntro")

func devolverBody():
	return cuerpo

func desactivar_colisiones():
	get_node("RayCastCabeza").enabled = false
	get_node("RayCastPisar").enabled = false
	get_node("Area2D/CollisionShape2D").set_deferred("disabled", true)

func activar_colisiones():
	get_node("RayCastCabeza").enabled = true
	get_node("RayCastPisar").enabled = true
	get_node("Area2D/CollisionShape2D").set_deferred("disabled", false)
