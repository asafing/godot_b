extends Node2D
class_name MonSkill

var description: String
var movement_speed: float
var skill_type: Enums.SkillType
var base_damage: float = 0
var possible_targets: Enums.PossibleTargets


func _on_init(name: String, description: String) -> void:
	self.description = description
	self.name = name


func _ready() -> void:
	$AnimatedSprite2D.play("repeat")
	movement_speed = get_meta("movement_speed", 0)


func _process(dt: float) -> void:
	position.x += cos(rotation) * movement_speed * dt
	position.y += sin(rotation) * movement_speed * dt


func calculate_damage(source_mon: Mon, target_mon: Mon) -> float:
	return base_damage


func cast(caster: Mon, target: Mon) -> void:
	var damage: float = calculate_damage(caster, target)
	target.take_damage(damage)


func get_description() -> String:
	assert("get_description must be overriden")
	return ""


func _get_description(format_params: Array) -> String:
	var post_format_params: Array[String] = []
	for param: String in format_params:
		post_format_params.push_back("<PARAM>" + str(param) + "</PARAM>")
	return description % post_format_params


# Node functions
func start_animation() -> void:
	$AnimatedSprite2D.play("repeat")


func _on_animated_sprite_2d_animation_looped() -> void:
	get_tree().current_scene.on_action_complete()
	queue_free()
