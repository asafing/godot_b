extends Control
class_name BattleScene

enum TurnState {NONE, PRE_TURN, ACTIONS_SELECT, PLAY_ACTIONS, POST_TURN}

var current_turn: int = 0
var turn_state: TurnState = TurnState.NONE

var active_mon: Mon
var active_mon_index: int = 0

var chosen_action_indexes: Array[int] = []
var chosen_action_target_indexes: Array[int] = []
var current_action_playing_index: int = 0

var player_mons: Array[Mon] = []
var enemy_mons: Array[Mon] = []

func _ready() -> void:
	$EnemySpots/VBoxContainer/Panel1/EnemyTopSpot/OccupyingMon/Sprite.flip_h = true
	$EnemySpots/VBoxContainer/Panel2/EnemyBotSpot/OccupyingMon/Sprite.flip_h = true
	player_mons.push_front($PlayerSpots/VBoxContainer/Panel1/PlayerTopSpot1.get_occupying_mon())
	player_mons.push_front($PlayerSpots/VBoxContainer/Panel2/PlayerTopSpot2.get_occupying_mon())
	$MainHud.battle_scene = self
	if turn_state == TurnState.NONE:
		start_pre_turn()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _set_active_mon(active_mon_index: int) -> void:
	self.active_mon = player_mons[active_mon_index]
	self.active_mon_index = active_mon_index
	$MainHud.active_mon = player_mons[active_mon_index]
	
func start_pre_turn() -> void:
	chosen_action_indexes.clear()
	chosen_action_target_indexes.clear()
	current_turn += 1
	_set_active_mon(0)
	print("Turn %d: Playing pre" % current_turn)
	
	start_action_select()

func start_action_select() -> void:
	turn_state = TurnState.ACTIONS_SELECT
	$MainHud.visible = true
	print("Turn %d: Starting action select" % current_turn)
	
func start_playing_actions() -> void:
	print("Turn %d: Playing actions" % current_turn)
	$MainHud.visible = false
	# For now do this in order, later by speed
	player_mons[0].play_action_towards(enemy_mons[0], chosen_action_indexes[0])

func start_post_turn() -> void:
	current_action_playing_index = 0
	print("Turn %d: Playing post turn" % current_turn)
	

func on_action_select(action_index: int) -> void:
	print("Turn %d: Action %d selected for monster indexed %d" % [current_turn, action_index, active_mon_index])
	chosen_action_indexes.push_front(action_index)
	if active_mon_index + 1 >= len(player_mons):
		start_playing_actions()
	else:
		_set_active_mon(active_mon_index + 1)

func _on_animation_complete() -> void:
	player_mons[0].inflict_damage()
	current_action_playing_index += 1
	if current_action_playing_index >= len(chosen_action_indexes):	
		start_post_turn()
	else:
		player_mons[current_action_playing_index].play_action_towards(enemy_mons[0], chosen_action_indexes[current_action_playing_index])
