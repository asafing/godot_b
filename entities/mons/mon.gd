extends Node2D
class_name Mon

var skill_factory: Resource = preload("res://entities/mon_skills/mon_skill.tscn")
var mon_skills: Dictionary = {
	"BasicAttack": preload("res://entities/mon_skills/basic_attack.gd"),
}

@export var health: float = 100
var actions: Array[MonSkill]
var max_action_count: int = 4
var action_key: String

var energy: int = 3
var action_ai: MonAI

var chosen_target: Mon
var chosen_action_index: int

var battle_spot: BattleSpot

func _ready() -> void:
	action_ai = MonAI.new(self, get_tree().current_scene)
	var skill_instance: MonSkill = skill_factory.instantiate()
	skill_instance.set_script(mon_skills["BasicAttack"])
	skill_instance.set_meta("movement_speed", 2200)
	skill_instance.scale = Vector2(2.5, 2.5)
	push_action(skill_instance)
	push_action(skill_instance)
	push_action(skill_instance)
	push_action(skill_instance)
	if battle_spot != null and battle_spot.spot_type == Enums.MonType.Enemy:
		$Sprite.flip_h = true


func push_action(action_key: MonSkill) -> void:
	actions.push_front(action_key)


func take_damage(damage: float) -> void:
	health -= damage


func apply_action() -> void:
	var action: MonSkill = actions[chosen_action_index]
	action.cast(self, chosen_target)


func play_action() -> void:
	if battle_spot != null and battle_spot.spot_type == Enums.MonType.Enemy:
		$Sprite.flip_h = true
	var skill_instance: MonSkill = actions[chosen_action_index]
	skill_instance.rotation = get_angle_to(chosen_target.global_position)
	add_child(skill_instance.duplicate())
