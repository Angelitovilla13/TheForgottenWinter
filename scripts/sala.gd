extends Node2D

func _ready():
	if Global.punto_spawn == "desde_cocina":
		$Jugador.position = Vector2(980, 460)
		$Jugador/Animacion.flip_h = true
		Global.punto_spawn = ""
