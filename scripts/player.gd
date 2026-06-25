extends CharacterBody2D

var SPEED = 300.0
const JUMP_VELOCITY = -700.0

@onready var player: CharacterBody2D = $"."
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hud: CanvasLayer = $"../HUD"
@onready var posicao_inicial: Marker2D = $"../PosicaoInicial"

# velocidade durante o power-up
const SPEED_BOOST=400.0
# segundos de duração
const BOOST_DURATION=5.0
# variável que controla quando o power-up está ativado ou não
var boosted=false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	# Inverte o sprite
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true	
		
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("walk")
	else:
			animated_sprite_2d.play("jump")

	move_and_slide()
	
func die():
	tomar_dano(1)
	
func tomar_dano(dano:int)->void:
	GameManager.vidas -= dano
	if GameManager.vidas <= 0:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	else:
		respawn();
	hud.atualizar_vidas()
	
func respawn() -> void:
	position = posicao_inicial.position
	
# função que aplica o aumento de velocidade
func apply_speed_boost():
	
	print("Boost aplicado! Velocidade = ", SPEED)
	# Se a variável boosted for true
	if boosted: 
		return
	# Sai da função sem fazer nada
	# evita empilhar o efeito, ou seja, ter vários boosts de uma vez
	# Senão, se a variável boosted for false, segue e muda para true
	boosted=true
	# Altere a velocidade para o valor da varíavel SPEED_BOOST
	SPEED=SPEED_BOOST
	# Cria um timer com a duração da variável BOOST_DURATION e pausa a função
	# até que esse tempo termine
	await get_tree().create_timer(BOOST_DURATION).timeout
	# retorna a variável velocidade ao valor original
	SPEED=200.0
	# volta a variável boosted para false, sinalizando que o power-up acabou
	boosted=false


	
 


func _on_powerup_speed_speed_collected(body: Variant) -> void:
	if body.has_method("apply_speed_boost"):
		body.apply_speed_boost()
