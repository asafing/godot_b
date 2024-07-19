extends Node2D
class_name AttackAnimation

var battle_scene: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_animation()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_animation() -> void:
	$AnimatedSprite2D.play("repeat")


func _on_animated_sprite_2d_animation_finished() -> void:
	battle_scene._on_animation_complete()
	#var curr_animation: String = $AnimatedSprite2D.animation
	#if curr_animation == "start":
		#$AnimatedSprite2D.play("start")
	#elif curr_animation == "end":
		#battle_scene.on_animation_end()
		
