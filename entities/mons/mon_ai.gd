extends Node
class_name MonAI

var chosen_target: Mon
var chosen_action_index: int
var battle_scene: BattleScene
var controller: Mon


func _init(controller: Mon, battle_scene: BattleScene) -> void:
	self.controller = controller
	self.battle_scene = battle_scene


func update_move_and_target() -> void:
	controller.chosen_action_index = 0
	controller.chosen_target = battle_scene.player_mons[0]
