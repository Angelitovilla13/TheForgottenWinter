extends Control

@export var imagenes: Array[Texture2D]
@export var tiempos: Array[float]
@export var textos: Array[String] # Nueva lista para los pensamientos

var imagen_actual = 0

func _ready():
	if imagenes.size() > 0:
		mostrar_imagen(0)

func mostrar_imagen(indice: int):
	$Pantalla.texture = imagenes[indice]
	
	# 1. Revisamos si esta imagen tiene algún pensamiento asignado
	if indice < textos.size() and textos[indice] != "":
		CajaDialogo.mostrar_dialogo(textos[indice])
	else:
		# Si esta imagen no lleva texto, ocultamos la caja por si quedó abierta de la anterior
		CajaDialogo.hide()
		
	# 2. Configuramos el tiempo de esta imagen
	if indice < tiempos.size() and tiempos[indice] > 0:
		$Timer.wait_time = tiempos[indice]
	else:
		$Timer.wait_time = 3.0
		
	$Timer.start()

func _on_timer_timeout():
	imagen_actual += 1
	
	if imagen_actual < imagenes.size():
		mostrar_imagen(imagen_actual)
	else:
		$Timer.stop()
		CajaDialogo.hide() # Nos aseguramos de limpiar la pantalla antes de ir a la sala
		print("Cinemática terminada, ¡Hora de iniciar el nivel!")
		get_tree().change_scene_to_file("res://escenas/sala.tscn")
