extends Node
class_name Mon

@export var health: float = 100
var actions: Array[MonSkill]
var max_action_count: int = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for _index in max_action_count:
		actions.append(BasicAttack.new())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func take_damage(damage: float) -> void:
	health -= damage
