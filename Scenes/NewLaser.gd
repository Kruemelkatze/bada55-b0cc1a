extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var color = 1
var max_cast = 0

export var is_colliding_with_target = false
export var is_colliding_with_laser = false
export var target_collision_point = Vector2.INF
export var laser_collision_point = Vector2.INF
var hit_target: Object = null

export var is_combined = false

func _init(combined = false):
	is_combined = combined

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_combined:
		collision_layer = 0
		collision_mask = 0
		$LaserRaycast.enabled = false
		$CollisionShape2D.disabled = true
		$Line2D.visible = false
		
	max_cast = get_viewport_rect().size.length()
	$Line2D.points[1].x = max_cast
	$TargetRaycast.cast_to = Vector2(max_cast, 0)
	$LaserRaycast.cast_to = Vector2(max_cast, 0)
	$Sprite.texture.flags = $Sprite.texture.flags | $Sprite.texture.FLAG_REPEAT
	set_open()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite.modulate = Color(1 if color & 4 else 0, 1 if color & 2 else 0, 1 if color & 1 else 0)	
	
	is_colliding_with_target = $TargetRaycast.is_colliding()
	target_collision_point = $TargetRaycast.get_collision_point() if is_colliding_with_target else Vector2.INF
	hit_target = $TargetRaycast.get_collider()
	
	if !is_combined:
		is_colliding_with_laser = $LaserRaycast.is_colliding()
		laser_collision_point = $LaserRaycast.get_collision_point() if is_colliding_with_laser else Vector2.INF
		
func get_hit_target():
	return hit_target
	
func set_to_position(global_position):
	var local_pos = to_local(global_position)
	var length = local_pos.length()
	$Sprite.position.x = length / 2
	$Sprite.region_rect.size.x = length
	
func set_open():
	$Sprite.position.x = max_cast /2
	$Sprite.region_rect.size.x = max_cast