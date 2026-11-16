extends Node2D

func _ready():
	if Global.punto_spawn == "desde_pasillo":
		$Jugador.position = Vector2(180, 540)
		$Jugador/Animacion.flip_h = false
		Global.punto_spawn = ""
