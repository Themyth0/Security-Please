extends Control
@export var next_scene: String = "res://Scenes/menu.tscn"

# NODES Sound
@onready var sfx_click = $SfxClick
@onready var sfx_success = $SfxSuccess
@onready var sfx_error = $SfxError

func _on_button_okey_pressed() -> void:
	$FirstPopup.visible = false

func _on_button_pressed() -> void:
	$BadAnswer.visible = true
	sfx_error.play()

func _on_button_2_pressed() -> void:
	$Password.visible = true
	sfx_error.play()

func _on_button_3_pressed() -> void:
	$Password.visible = true
	sfx_error.play()

func _on_button_4_pressed() -> void:
	$Password.visible = true
	sfx_error.play()

func _on_button_5_pressed() -> void:
	$BadAnswer.visible = true
	sfx_error.play()

func _on_close_pressed() -> void:
	$Password.visible = false

func _on_close_bad_pressed() -> void:
	$BadAnswer.visible = false
	sfx_error.play()

func _on_close_good_pressed() -> void:
	$GoodAnswer.visible = false

func _on_button_6_pressed() -> void:
	$GoodAnswer.visible = true
	sfx_success.play()
	await get_tree().create_timer(1.5).timeout
	var error = get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	
	
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if sfx_click:
				sfx_click.play()
