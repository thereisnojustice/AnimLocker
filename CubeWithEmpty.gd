extends Node3D

@export var other_cube_path : NodePath
@onready var other_cube = get_node(other_cube_path)
@onready var locker = $AnimLocker
var rotate_the_cube = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("move_other_cube"):
		# Pass in the (other_node, "Parent animation name", "Child animation name")
		locker.start_lock_with_child_node(other_cube, "Idle", "Bounce")
	if Input.is_action_just_released("rotate_cube_toggle"):
		rotate_the_cube = !rotate_the_cube
	if !rotate_the_cube:
		return
	global_rotation.y = global_rotation.y + 1 * delta
