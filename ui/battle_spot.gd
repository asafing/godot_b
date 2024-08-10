extends Control

@export var spot_index: int = 0
@export var spot_type: Enums.MonType = Enums.MonType.Enemy


func _ready() -> void:
	$SpotTexture/ProgressBar.max_value = $OccupyingMon.health


func _process(delta: float) -> void:
	$SpotTexture/ProgressBar.value = $OccupyingMon.health


func get_occupying_mon() -> Mon:
	return $OccupyingMon


func _on_mouse_focus_box_pressed() -> void:
	get_tree().current_scene.on_target_select(spot_index, spot_type)


func _on_mouse_focus_box_mouse_entered() -> void:
	$SelectOutline.visible = true


func _on_mouse_focus_box_mouse_exited() -> void:
	$SelectOutline.visible = false
