extends Control

var active_mon: Mon
var battle_scene: Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_attack_1_button_pressed() -> void:
	battle_scene.on_action_select(0)


func _on_attack_2_button_pressed() -> void:
	battle_scene.on_action_select(1)


func _on_attack_3_button_pressed() -> void:
	battle_scene.on_action_select(2)


func _on_attack_4_button_pressed() -> void:
	battle_scene.on_action_select(3)
