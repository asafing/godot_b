extends Control
class_name BattleSpot

@export var spot_index: int = 0
@export var spot_type: Enums.MonType = Enums.MonType.Enemy
var occupying_mon: Mon = Mon.new()

func _ready() -> void:
	$TurnOrder.pause()

func _process(delta: float) -> void:
	if occupying_mon != null:
		$SpotTexture/ProgressBar.value = occupying_mon.health


func set_occupying_mon(mon: Mon) -> void:
	remove_child(occupying_mon)
	occupying_mon.queue_free()
	occupying_mon = mon
	occupying_mon.battle_spot = self
	add_child(occupying_mon)
	$SpotTexture/ProgressBar.max_value = occupying_mon.health

func _on_mouse_focus_box_pressed() -> void:
	get_tree().current_scene.on_target_select(spot_index, spot_type)


func _on_mouse_focus_box_mouse_entered() -> void:
	$SelectOutline.visible = true


func _on_mouse_focus_box_mouse_exited() -> void:
	$SelectOutline.visible = false

func set_playing_order(play_order: int) -> void:
	$TurnOrder.stop()
	$TurnOrder.set_frame_and_progress(play_order, 0)
