extends Node2D

func _ready():
	if Global.punto_spawn == "desde_sala":
		$Jugador.position = Vector2(130, 560)
		$Jugador/Animacion.flip_h = false
		Global.punto_spawn = ""
	elif Global.punto_spawn == "desde_pasillo":
		$Jugador.position = Vector2(1010, 470)
		$Jugador/Animacion.flip_h = true
		Global.punto_spawn = ""


var pensamiento_visto = false

func _on_trigger_pensamiento_body_entered(body):
	# Ahora le preguntamos al Cerebro Global si ya tuvimos este pensamiento
	if body.name == "Jugador" and Global.pensamiento_cocina == false and Global.nota_leida == false:
		
		CajaDialogo.mostrar_dialogo("Sherlyn: (Siempre me trata como a una niña chiquita...)")
		
		# Le avisamos al Cerebro Global que esto ya pasó para que no se repita nunca
		Global.pensamiento_cocina = true
