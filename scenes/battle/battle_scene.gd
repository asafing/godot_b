extends Control
class_name BattleScene

var active_mon: Mon
var active_mon_index: int = 0

var mon_factory: Resource = preload("res://entities/mons/mon_scene.tscn")

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var player_mons: Array[Mon] = []
var enemy_mons: Array[Mon] = []
var mons_turn_order: Array[Mon] = []

var turn: TurnData = TurnData.new()


func _ready() -> void:
	var mon1: Mon = mon_factory.instantiate()
	var mon2: Mon = mon_factory.instantiate()
	var mon3: Mon = mon_factory.instantiate()
	var mon4: Mon = mon_factory.instantiate()
	$PlayerSpots/VBoxContainer/TopPanel/PlayerSpot.set_occupying_mon(mon1)
	$PlayerSpots/VBoxContainer/BotPanel/PlayerSpot.set_occupying_mon(mon2)
	$EnemySpots/VBoxContainer/TopPanel/EnemySpot.set_occupying_mon(mon3)
	$EnemySpots/VBoxContainer/BotPanel/EnemySpot.set_occupying_mon(mon4)
	player_mons.push_back(mon1)
	player_mons.push_back(mon2)
	enemy_mons.push_back(mon3)
	enemy_mons.push_back(mon4)
	
	player_mons[0].speed = 10
	enemy_mons[0].speed = 5
	player_mons[1].speed = 2
	enemy_mons[1].speed = 2
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
	update_mons_turn_priorty()
	start_action_select()


func start_action_select() -> void:
	turn.current_state = Enums.TurnState.ACTIONS_SELECT
	$MainHud.visible = true
	print("Turn %d: Starting action select" % turn.current_turn)


func start_target_select() -> void:
	turn.current_state = Enums.TurnState.TARGET_SELECT
	#$MainHud.visible = false
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
		|| possible_targets == Enums.PossibleTargets.All
	):
		$PlayerSpots/VBoxContainer/TopPanel/PlayerSpot/MouseFocusBox.visible = true
		$PlayerSpots/VBoxContainer/BotPanel/PlayerSpot/MouseFocusBox.visible = true
	if possible_targets == Enums.PossibleTargets.AllOthers:
		if active_mon_index == 0:
			$PlayerSpots/VBoxContainer/BotPanel/PlayerSpot/MouseFocusBox.visible = true
		elif active_mon_index == 1:
			$PlayerSpots/VBoxContainer/TopPanel/PlayerSpot/MouseFocusBox.visible = true
			


func start_playing_actions() -> void:
	turn.current_state = Enums.TurnState.PLAY_ACTIONS
	print("Turn %d: Playing actions" % turn.current_turn)
	$MainHud.visible = false
	mons_turn_order[0].play_action()


func start_post_turn() -> void:
	turn.current_state = Enums.TurnState.POST_TURN
	turn.action_playing_index = 0
	print("Turn %d: Playing post turn" % turn.current_turn)
	start_pre_turn()


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

func _sort_by_speed(a: Mon, b: Mon) -> bool:
	if a.speed > b.speed:
		return true
	elif a.speed == b.speed:
		return [a, b].pick_random() == a
	return false


func update_mons_turn_priorty() -> void:
	self.mons_turn_order = (player_mons + enemy_mons)
	self.mons_turn_order.sort_custom(_sort_by_speed)
	for mon_turn in range(len(mons_turn_order)):
		mons_turn_order[mon_turn].battle_spot.set_playing_order(mon_turn)
