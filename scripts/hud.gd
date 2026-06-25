extends CanvasLayer

@onready var health_label: Label = $Control/HealthLabel
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	atualizar_vidas()

func atualizar_vidas():
	health_label.text = "Vidas: " + str(GameManager.vidas)
