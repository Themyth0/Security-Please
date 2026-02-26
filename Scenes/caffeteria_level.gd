extends Control


func _on_button_okey_pressed() -> void:
	$FirstPopup.visible = false

func _on_button_pressed() -> void:
	$BadAnswer.visible = true

func _on_button_2_pressed() -> void:
	$Password.visible = true

func _on_button_3_pressed() -> void:
	$Password.visible = true

func _on_button_4_pressed() -> void:
	$Password.visible = true

func _on_button_5_pressed() -> void:
	$BadAnswer.visible = true

func _on_close_pressed() -> void:
	$Password.visible = false

func _on_close_bad_pressed() -> void:
	$BadAnswer.visible = false

func _on_close_good_pressed() -> void:
	$GoodAnswer.visible = false

func _on_button_6_pressed() -> void:
	$GoodAnswer.visible = true
