extends MonSkill
class_name BasicAttack

static var global_name: String = "Basic Attack"
static var global_desc: String = "Attack an enemy for %s damage"


func _init() -> void:
	_on_init(global_name, global_desc)
	base_damage = 20
	possible_targets = Enums.PossibleTargets.AllOthers


func get_description() -> String:
	return super._get_description([base_damage])
