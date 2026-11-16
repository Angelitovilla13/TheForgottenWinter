extends Area2D

var cambiando = false

func _on_body_entered(body):
	if body.name == "Jugador" and not cambiando:
		cambiando = true
		Global.punto_spawn = "desde_pasillo"
		get_tree().call_deferred("change_scene_to_file", "res://escenas/cocina.tscn")
