extends Control

var active_mon: Mon
var battle_scene: BattleScene
var mouse_in_grid: bool


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var line: CurvedLine2D = $ActionsGrid/Panel2/Control/TargetSelectLine
	line.target_point = get_global_mouse_position() - line.global_position
	$ActionsGrid/Panel2/Control/TargetSelectLine/LineEnd.position = line.points[-1]
	$ActionsGrid/Panel2/Control/TargetSelectLine/LineEnd.rotation_degrees = rad_to_deg(line.end_angle)
	
	var mouse_below_ui: bool = get_global_mouse_position().y > $ActionsGrid.position.y
	if battle_scene.turn.current_state == Enums.TurnState.TARGET_SELECT:
		if mouse_below_ui:
			line.visible = false
		else:
			line.visible = true
	else:
		line.visible = false
		


func _on_attack_1_button_pressed() -> void:
	battle_scene.on_action_select(0)


func _on_attack_2_button_pressed() -> void:
	battle_scene.on_action_select(1)


func _on_attack_3_button_pressed() -> void:
	battle_scene.on_action_select(2)


func _on_attack_4_button_pressed() -> void:
	battle_scene.on_action_select(3)
