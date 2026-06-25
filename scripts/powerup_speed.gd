extends Area2D

# Sinal que será emitido quando o jogador tocar o coletável,
# enviando o body (jogador) como parâmetro.
signal speed_collected(body)

@onready var particles: GPUParticles2D = $Particles
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _on_body_entered(body: Node2D) -> void:
	print("Coletável tocado!")
 	# Verifica se quem entrou é o Player
	if body.name == "Player":
		# Emite o sinal enviando o player para quem estiver ouvindo
		speed_collected.emit(body)
		
		# Torna o coletável invisível
		sprite_2d.visible = false
		# Desativa o colisor para evitar múltiplas colisões
		collision_shape_2d.set_deferred("disabled", true)
		
		# Aguarda as partículas terminarem a animação
		await particles.finished
		# Remove o coletável da cena
		queue_free()
