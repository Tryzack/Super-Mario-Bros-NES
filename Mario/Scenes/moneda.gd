extends StaticBody2D

func _ready():
	get_node("AnimationPlayer").play("idle")
