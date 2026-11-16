extends Node2D

func _ready():
	if Global.punto_spawn == "desde_pasillo":
		$Jugador.position = Vector2(950, 580)
		$Jugador/Animacion.flip_h = true
		Global.punto_spawn = ""
