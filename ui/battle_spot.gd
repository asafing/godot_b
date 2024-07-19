extends Node2D


func _ready() -> void:
	$SpotTexture/ProgressBar.max_value = $OccupyingMon.health


func _process(delta: float) -> void:
	$SpotTexture/ProgressBar.value = $OccupyingMon.health


func get_occupying_mon() -> Mon:
	return $OccupyingMon
