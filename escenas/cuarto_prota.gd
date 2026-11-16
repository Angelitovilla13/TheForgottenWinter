extends Node2D

var jugador_cerca_nota = false
var nota_abierta = false
var _en_nota_cama: bool = false
var _en_area_carta: bool = false
var _esperando_dialogo_nieve: bool = false
var jugador_cerca_gato: bool = false
var interacciones_gato: int = 0
var jugador_cerca_cama: bool = false
var jugador_cerca_libro: bool = false

func _ready():
	$TriggerEntrada.body_entered.connect(_on_puerta_cruzada)
	$NotaCama.body_entered.connect(_on_cama_entrada)
	$NotaCama.body_exited.connect(_on_cama_salida)
	$AreaCarta.body_entered.connect(_on_area_carta_entrada)
	$AreaCarta.body_exited.connect(_on_area_carta_salida)
	$AreaGato.body_entered.connect(_on_gato_entrada)
	$AreaGato.body_exited.connect(_on_gato_salida)
	$AreaCama.body_entered.connect(_on_area_cama_entrada)
	$AreaCama.body_exited.connect(_on_area_cama_salida)
	$AreaLibro.body_entered.connect(_on_area_libro_entrada)
	$AreaLibro.body_exited.connect(_on_area_libro_salida)
	if not CajaDialogo.secuencia_terminada.is_connected(_on_dialogo_terminado):
		CajaDialogo.secuencia_terminada.connect(_on_dialogo_terminado)
	$CartaCama.visible = true
	$CartaCama/Contorno.visible = false
	$AreaGato/Contorno.visible = false
	$AreaCama/Contorno.visible = false
	$AreaLibro/Contorno.visible = false
	
	# Le preguntamos al cerebro si ya leímos la nota
	if Global.nota_leida == true:
		$ModulacionNoche.color = Color(0.15, 0.2, 0.35) 
		$Nieve.visible = true
		$Nieve.emitting = true 
		$AudioNieve.play()
		$TriggerEntrada.set_deferred("monitoring", false)
	else:
		$Nieve.visible = false
		$Nieve.emitting = false
		$AudioNieve.stop()

func _on_puerta_cruzada(body):
	if body.name == "Jugador" and Global.nota_leida:
		$Nieve.visible = true
		$Nieve.emitting = true
		$TriggerEntrada.set_deferred("monitoring", false)

func _on_cama_entrada(body):
	if body.name == "Jugador":
		_en_nota_cama = true
		jugador_cerca_nota = true
		_actualizar_contorno_carta()
		print("Sherlyn está tocando la cama. Lista para leer.") # <--- Chivato 1

func _on_cama_salida(body):
	if body.name == "Jugador":
		_en_nota_cama = false
		jugador_cerca_nota = _en_nota_cama or _en_area_carta
		_actualizar_contorno_carta()
		print("Sherlyn se alejó de la cama.") # <--- Chivato 2

func _on_area_carta_entrada(body):
	if body.name == "Jugador":
		_en_area_carta = true
		jugador_cerca_nota = true
		_actualizar_contorno_carta()

func _on_area_carta_salida(body):
	if body.name == "Jugador":
		_en_area_carta = false
		jugador_cerca_nota = _en_nota_cama or _en_area_carta
		_actualizar_contorno_carta()

func _actualizar_contorno_carta():
	$CartaCama/Contorno.visible = jugador_cerca_nota and not nota_abierta
	_actualizar_contorno_cama()

func _on_gato_entrada(body):
	if body.name == "Jugador":
		jugador_cerca_gato = true
		_actualizar_contorno_gato()

func _on_gato_salida(body):
	if body.name == "Jugador":
		jugador_cerca_gato = false
		_actualizar_contorno_gato()

func _actualizar_contorno_gato():
	$AreaGato/Contorno.visible = jugador_cerca_gato and not nota_abierta and not CajaDialogo.visible

func _on_area_cama_entrada(body):
	if body.name == "Jugador":
		jugador_cerca_cama = true
		_actualizar_contorno_cama()

func _on_area_cama_salida(body):
	if body.name == "Jugador":
		jugador_cerca_cama = false
		_actualizar_contorno_cama()

func _actualizar_contorno_cama():
	$AreaCama/Contorno.visible = jugador_cerca_cama and not jugador_cerca_nota and not nota_abierta and not CajaDialogo.visible

func _on_area_libro_entrada(body):
	if body.name == "Jugador":
		jugador_cerca_libro = true
		_actualizar_contorno_libro()

func _on_area_libro_salida(body):
	if body.name == "Jugador":
		jugador_cerca_libro = false
		_actualizar_contorno_libro()

func _actualizar_contorno_libro():
	$AreaLibro/Contorno.visible = jugador_cerca_libro and not nota_abierta and not CajaDialogo.visible

func _on_dialogo_terminado():
	_actualizar_contorno_gato()
	_actualizar_contorno_cama()
	_actualizar_contorno_libro()

func _interactuar_con_cama():
	var dialogos_cama: Array[String] = [
		"Sherlyn: No tengo nada de sueño.",
		"Sherlyn: Dormir se ha vuelto una causa perdida."
	]
	CajaDialogo.mostrar_secuencia(dialogos_cama)
	_actualizar_contorno_cama()

func _interactuar_con_libro():
	var dialogos_libro: Array[String] = [
		"Sherlyn: De verdad me da pereza la tarea ahora.",
		"Sherlyn: Quizás algún día termine la tarea."
	]
	CajaDialogo.mostrar_secuencia(dialogos_libro)
	_actualizar_contorno_libro()

func _interactuar_con_gato():
	$AudioGato.play()
	if interacciones_gato == 0:
		CajaDialogo.mostrar_dialogo("Sherlyn: Mi gatita Luna.")
		interacciones_gato = 1
	elif interacciones_gato == 1:
		var dialogos_luna: Array[String] = [
			"Sherlyn: Siempre está ahí durmiendo la floja...",
			"Sherlyn: ...cómo me gustaría ser ella."
		]
		CajaDialogo.mostrar_secuencia(dialogos_luna)
		interacciones_gato = 2
	else:
		CajaDialogo.mostrar_dialogo("Sherlyn: Solo mi gatita me entiende.")
		interacciones_gato = 0
	_actualizar_contorno_gato()

func _unhandled_input(event):
	if _esperando_dialogo_nieve or (CajaDialogo.visible and not nota_abierta):
		return
	# Si presiona la 'X' en el control (o Enter en teclado)
	if event.is_action_pressed("ui_accept"):
		if nota_abierta == true:
			# Si la nota ya estaba abierta, la cerramos
			$UINota.visible = false
			nota_abierta = false
			_actualizar_contorno_carta()
			get_viewport().set_input_as_handled()
			print("Nota cerrada.")
			
			# (OPCIONAL) Si quieres que al cerrar la nota la luz vuelva 
			# a la normalidad, descomenta la siguiente línea quitándole el #:
			# $ModulacionNoche.color = Color(1, 1, 1)
			
			var primera_lectura: bool = not Global.nota_leida
			Global.nota_leida = true
			$Nieve.visible = true
			$Nieve.emitting = true
			if not $AudioNieve.playing:
				$AudioNieve.play()
			if primera_lectura:
				_esperando_dialogo_nieve = true
				await get_tree().create_timer(0.5).timeout
				_esperando_dialogo_nieve = false
				if is_inside_tree():
					CajaDialogo.mostrar_dialogo("Sherlyn: ¿Está... nevando...?")
			
		elif jugador_cerca_nota == true:
			# Si la nota estaba cerrada y Sherlyn está cerca de la cama
			$UINota.visible = true
			$ModulacionNoche.color = Color(0.15, 0.2, 0.35) # Tono terrorífico
			nota_abierta = true
			_actualizar_contorno_carta()
			get_viewport().set_input_as_handled()
		elif jugador_cerca_gato == true:
			_interactuar_con_gato()
			get_viewport().set_input_as_handled()
		elif jugador_cerca_cama == true:
			_interactuar_con_cama()
			get_viewport().set_input_as_handled()
		elif jugador_cerca_libro == true:
			_interactuar_con_libro()
			get_viewport().set_input_as_handled()
