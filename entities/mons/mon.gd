extends Node
class_name Mon

var skill_factory: Resource = preload("res://entities/mon_skills/mon_skill.tscn")
var mon_skills: Dictionary = {
	"BasicAttack": preload("res://entities/mon_skills/basic_attack.gd"),
}

@export var health: float = 100
var action_keys: Array[String]
var max_action_count: int = 4
var action_key: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	push_action("BasicAttack")
	push_action("BasicAttack")
	push_action("BasicAttack")
	push_action("BasicAttack")


func push_action(action_key: String) -> void:
	action_keys.push_front(action_key)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func take_damage(damage: float) -> void:
	health -= damage


func inflict_damage(target_mon: Mon, action_index: int) -> void:
	target_mon.take_damage(5)
	#var skill: MonSkill =  mon_skills[action_index]


func play_action_towards(target_mon: Mon, action_index: int) -> void:
	var skill_instance: MonSkill = skill_factory.instantiate()
	var action_script_key: String = action_keys[action_index]
	skill_instance.set_script(mon_skills[action_script_key])
	add_child(skill_instance)
