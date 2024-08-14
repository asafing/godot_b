extends Line2D
class_name CurvedLine2D

var curve2d: Curve2D = Curve2D.new()
var target_point: Vector2
var end_angle: float = 0

func _ready() -> void:
	curve2d.add_point(points[0])
	curve2d.add_point(points[1])
	target_point = curve2d.get_point_position(1)

func _process(_dt: float) -> void:
	curve2d.set_point_position(1, target_point)
	var y_distance: float = curve2d.get_point_position(1).y - curve2d.get_point_position(0).y
	var x_distance: float = curve2d.get_point_position(1).x - curve2d.get_point_position(0).x
	var point_in: Vector2 = Vector2(x_distance * -1.2, y_distance * 0.3)
	curve2d.set_point_in(1, point_in)
	self.points = curve2d.get_baked_points()
	end_angle = deg_to_rad(90) - points[-2].angle_to_point(points[-1])
	
