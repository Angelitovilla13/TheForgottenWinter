extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# Le preguntamos al Cerebro Global si la mamá ya la regañó y si aún no leemos la nota del cuarto
	if Global.regano_mama == false and Global.nota_leida == false:
		
		# Mostramos el regaño
		CajaDialogo.mostrar_dialogo("Mamá: Sherlyn, ya es muy tarde. Vete a tu cuarto a dormir. (entra a su cuarto)")
		
		# Le avisamos al Cerebro Global que la mamá ya habló para que no lo vuelva a hacer
		Global.regano_mama = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
