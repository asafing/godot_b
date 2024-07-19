extends MonSkill
class_name BasicAttack

var base_damage: int = 20

static var global_name: String = "Basic Attack"
static var global_desc: String = "Attack an enemy for %s damage"

func _init() -> void:
	_on_init(global_name, global_desc)

func cast(caster: Mon, target: Mon) -> void:
	target.take_damage(base_damage)
	
func get_description() -> String:
	return super._get_description([base_damage])
