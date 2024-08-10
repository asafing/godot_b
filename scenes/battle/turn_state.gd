class_name TurnData

var action_playing_index: int = 0
var action_selecting_index: int = 0

var current_turn: int = 0
var current_state: Enums.TurnState = Enums.TurnState.NONE


func clear() -> void:
	action_playing_index = 0
	action_selecting_index = 0
