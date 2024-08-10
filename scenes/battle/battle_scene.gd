extends Control
class_name BattleScene

var active_mon: Mon
var active_mon_index: int = 0

#var chosen_action_indexes: Array[int] = []
#var chosen_action_target_indexes: Array[int] = []
#var current_action_playing_index: int = 0
#var current_action_selecting_index: int = 0

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var player_mons: Array[Mon] = []
var enemy_mons: Array[Mon] = []
var mons_turn_order: Array[Mon] = []

var turn: TurnData = TurnData.new()


func _ready() -> void:
	$EnemySpots/VBoxContainer/TopPanel/EnemySpot/OccupyingMon/Sprite.flip_h = true
	$EnemySpots/VBoxContainer/BotPanel/EnemySpot/OccupyingMon/Sprite.flip_h = true
	player_mons.push_back($PlayerSpots/VBoxContainer/TopPanel/PlayerSpot.get_occupying_mon())
	player_mons.push_back($PlayerSpots/VBoxContainer/BotPanel/PlayerSpot.get_occupying_mon())
	enemy_mons.push_back($EnemySpots/VBoxContainer/TopPanel/EnemySpot.get_occupying_mon())
	enemy_mons.push_back($EnemySpots/VBoxContainer/BotPanel/EnemySpot.get_occupying_mon())
	player_mons[0].speed = 10
	enemy_mons[0].speed = 3
	player_mons[1].speed = 0
	enemy_mons[1].speed = -1
	$MainHud.battle_scene = self
	if turn.current_state == Enums.TurnState.NONE:
		start_pre_turn()


func _set_active_mon(active_mon_index: int) -> void:
	self.active_mon = player_mons[active_mon_index]
	self.active_mon_index = active_mon_index
	$MainHud.active_mon = player_mons[active_mon_index]


func start_pre_turn() -> void:
	turn.current_state = Enums.TurnState.PRE_TURN
	turn.clear()
	turn.current_turn += 1
	_set_active_mon(0)
	print("Turn %d: Playing pre" % turn.current_turn)
	for mon in enemy_mons:
		mon.action_ai.update_move_and_target()
	start_action_select()


func start_action_select() -> void:
	turn.current_state = Enums.TurnState.ACTIONS_SELECT
	$MainHud.visible = true
	print("Turn %d: Starting action select" % turn.current_turn)


func start_target_select() -> void:
	$MainHud.visible = false
	var possible_targets: Enums.PossibleTargets = (
		active_mon.actions[turn.action_selecting_index].possible_targets
	)
	if (
		possible_targets == Enums.PossibleTargets.Enemies
		|| possible_targets == Enums.PossibleTargets.AllOthers
		|| possible_targets == Enums.PossibleTargets.All
	):
		$EnemySpots/VBoxContainer/TopPanel/EnemySpot/MouseFocusBox.visible = true
		$EnemySpots/VBoxContainer/BotPanel/EnemySpot/MouseFocusBox.visible = true
	if (
		possible_targets == Enums.PossibleTargets.Ally
		|| possible_targets == Enums.PossibleTargets.AllOthers
		|| possible_targets == Enums.PossibleTargets.All
	):
		$PlayerSpots/VBoxContainer/TopPanel/PlayerSpot/MouseFocusBox.visible = true
		$PlayerSpots/VBoxContainer/BotPanel/PlayerSpot/MouseFocusBox.visible = true


func start_playing_actions() -> void:
	turn.current_state = Enums.TurnState.PLAY_ACTIONS
	print("Turn %d: Playing actions" % turn.current_turn)
	$MainHud.visible = false
	update_mons_turn_priorty()
	mons_turn_order[0].play_action()


func start_post_turn() -> void:
	turn.current_state = Enums.TurnState.POST_TURN
	turn.action_playing_index = 0
	print("Turn %d: Playing post turn" % turn.current_turn)
	start_pre_turn()


func _sort_by_speed(a: Mon, b: Mon) -> bool:
	if a.speed > b.speed:
		return true
	elif a.speed == b.speed:
		if rng.randi_range(0, 1) == 1:
			return true
		else:
			return false
	return false


func update_mons_turn_priorty() -> void:
	self.mons_turn_order = (player_mons + enemy_mons)
	self.mons_turn_order.sort_custom(_sort_by_speed)


# Triggers as callback when action is selected from the HUD
func on_action_select(action_index: int) -> void:
	turn.action_selecting_index = action_index
	start_target_select()


# Triggers as callback when action completes playing
func on_action_complete() -> void:
	mons_turn_order[turn.action_playing_index].apply_action()
	turn.action_playing_index += 1
	if turn.action_playing_index >= len(mons_turn_order):
		start_post_turn()
	else:
		mons_turn_order[turn.action_playing_index].play_action()


# Triggers when a target is selected for an action
func on_target_select(spot_index: int, mon_target_type: Enums.MonType) -> void:
	var mons_arr: Array[Mon] = enemy_mons if mon_target_type == Enums.MonType.Enemy else player_mons
	active_mon.chosen_target = mons_arr[spot_index]
	active_mon.chosen_action_index = turn.action_selecting_index

	if active_mon_index + 1 >= len(player_mons):
		start_playing_actions()
	else:
		_set_active_mon(active_mon_index + 1)
		start_action_select()
	$PlayerSpots/VBoxContainer/TopPanel/PlayerSpot/MouseFocusBox.visible = false
	$PlayerSpots/VBoxContainer/BotPanel/PlayerSpot/MouseFocusBox.visible = false
	$EnemySpots/VBoxContainer/TopPanel/EnemySpot/MouseFocusBox.visible = false
	$EnemySpots/VBoxContainer/BotPanel/EnemySpot/MouseFocusBox.visible = false
