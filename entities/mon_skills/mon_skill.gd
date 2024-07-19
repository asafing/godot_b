extends Node2D
class_name MonSkill

var description: String


func _on_init(name: String, description: String) -> void:
	self.description = description
	self.name = name
	$AnimatedSprite2D.play("repeat")


func cast(_caster: Mon, _target: Mon) -> void:
	assert("cast must be overriden")


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
	get_tree().current_scene._on_action_complete()
	queue_free()
