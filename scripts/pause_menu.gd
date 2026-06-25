extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event)->void:
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			hide()
			get_tree().paused=false
		else:
			show()
			get_tree().paused=true
			


func _on_continuar_button_pressed() -> void:
	hide()
	get_tree().paused=false

func _on_menu_principal_button_pressed() -> void:
	get_tree().paused=false
	get_tree().change_scene_to_file("res://scenes/menu_inicial.tscn")
